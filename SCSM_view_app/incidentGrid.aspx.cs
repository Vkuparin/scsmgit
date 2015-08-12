using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;
using System.Diagnostics;
using System.DirectoryServices;
using System.DirectoryServices.ActiveDirectory;
using System.DirectoryServices.AccountManagement;
using System.Web.Providers.Entities;
using System.Web.Security;

namespace show_incident
{
    public partial class incidentGrid : System.Web.UI.Page
    {
        private static string[] _userInfoAD = null;
        protected static string userFullName { get { return _userInfoAD[0]; } }


        private static string _userAccountName = null;
        protected static string userAccountName { get { return _userAccountName; } }


        public struct s_GridResult
        {
            public int page;
            public int total;
            public int record;
            public s_RowData[] rows;

        }
        public struct s_RowData
        {
            public int id;
            public string[] cell;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            _userAccountName = User.Identity.Name.ToString().Substring(8);


            // Täytä tähän oma käyttäjätunnus - slahdeti 082015 
            using (DirectoryEntry de = new DirectoryEntry("LDAP://adturku.fi"))
            {
                using (DirectorySearcher adSearch = new DirectorySearcher(de))
                {
                    adSearch.PropertiesToLoad.Add("cn");  // Kokonimi
                    adSearch.Filter = "(sAMAccountName=" + userAccountName + ")"; //haku käyttäjänimellä
                    SearchResult adSearchResult = adSearch.FindOne();
                    var searchPropCollection = adSearchResult.Properties;
                    string[] info = new string[5];
                    int infoRivi = 0;
                    foreach (string tulos in searchPropCollection.PropertyNames)
                    {

                        if (tulos.Equals("cn"))
                        {
                            infoRivi = 0;
                        }
                        if (tulos.Equals("adspath"))
                        {
                            continue;
                        }

                        foreach (Object myCollection in searchPropCollection[tulos])
                        {
                            info[infoRivi] = myCollection.ToString();
                        }
                    }
                    _userInfoAD = info;
                }
            }
        }
        [WebMethod]
        public static s_GridResult GetDataTable(string _search, string nd, int rows, int page, string sidx, string sord)
        {
            string user = userAccountName;
            Debug.WriteLine(user + " KÄYTTÄJÄN NIMI GRID HAUSSA");
            int startindex = (page - 1);
            int endindex = page;
            string sql = @"SELECT Id_9A505725_E2F2_447F_271B_9B9F4F0D190C as Id
                        ,[Title_9691DD10_7211_C835_E3E7_6B38AF8B8104] as Title
                        ,[Description_59B77FD5_FE0E_D2B5_D541_0EBBD1EC9A2B] as Description
                        ,[ResolutionDescription_85E8B5FA_3ECB_9B6C_0A02_A8C9EC085A39] as ResolutionDescription
                        ,IncidentStatus.[DisplayName] as IncidentStatus
                        ,[CreatedDate_6258638D_B885_AB3C_E316_D00782B8F688] as CreatedDate
                        ,AssignedToUser.[DisplayName] as AssignedToUser
                        ,AffectedUser.UserName_6AF77E23_669B_123F_B392_323C17097BBD AffectedUsername
                        ,AffectedUser.DisplayName as AffectedUser
                        ,AssignedToUser.UserName_6AF77E23_669B_123F_B392_323C17097BBD as AssignedUsername
                        ,IncidentClassification.[DisplayName] as IncidentClassification
                        ,[Priority_B930B964_A1C4_0B5A_B2D1_BFBE9ECDC794] as Priority 
                        ,[ResolvedDate_D2A4C73F_01B8_29C5_895B_5BE4C3DFAC4E] as ResolvedDate
                        ,[Escalated_525F1F92_CEB3_079D_C0A5_E7A06AC4D6A5] as Escalated

                        FROM [ServiceManager].[dbo].[MT_System$WorkItem$Incident]
                        INNER JOIN [ServiceManager].[dbo].[Relationship] AssignedToUserRel ON
                        [ServiceManager].[dbo].[MT_System$WorkItem$Incident].[BaseManagedEntityId] = AssignedToUserRel.[SourceEntityId]
                        AND AssignedToUserRel.[RelationshipTypeId] = '15E577A3-6BF9-6713-4EAC-BA5A5B7C4722'
                        INNER JOIN [ServiceManager].[dbo].[MT_System$Domain$User] AssignedToUser ON
                        AssignedToUserRel.[TargetEntityId] = AssignedToUser.[BaseManagedEntityId]

                        INNER JOIN [ServiceManager].[dbo].[Relationship] AffectedUserRel ON
                        [ServiceManager].[dbo].[MT_System$WorkItem$Incident].[BaseManagedEntityId] = AffectedUserRel.[SourceEntityId]
                        AND AffectedUserRel.[RelationshipTypeId] = 'DFF9BE66-38B0-B6D6-6144-A412A3EBD4CE'
                        INNER JOIN [ServiceManager].[dbo].[MT_System$Domain$User] AffectedUser ON
                        AffectedUserRel.[TargetEntityId] = AffectedUser.[BaseManagedEntityId]

                        INNER JOIN [ServiceManager].[dbo].[DisplayStringView] IncidentClassification ON
                        [ServiceManager].[dbo].[MT_System$WorkItem$Incident].[Classification_00B528BF_FB8F_2ED4_2434_5DF2966EA5FA] = IncidentClassification.LTStringId
                        AND IncidentClassification.LanguageCode = 'ENU'

                        INNER JOIN [ServiceManager].[dbo].[DisplayStringView] IncidentStatus ON
                        [ServiceManager].[dbo].[MT_System$WorkItem$Incident].[Status_785407A9_729D_3A74_A383_575DB0CD50ED] = IncidentStatus.LTStringId
                        AND IncidentStatus.LanguageCode = 'ENU'

                        WHERE AffectedUser.[UserName_6AF77E23_669B_123F_B392_323C17097BBD] = '" + user+"' ;";


            DataTable dt = new DataTable();
            SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["tkuscsm-dwsConnectionString"].ConnectionString);
            SqlDataAdapter adapter = new SqlDataAdapter(sql, conn);
            adapter.Fill(dt);
            s_GridResult result = new s_GridResult();
            List<s_RowData> rowsadded = new List<s_RowData>();
            int idx = 1;
            foreach (DataRow row in dt.Rows)
            {
                s_RowData newrow = new s_RowData();
                newrow.id = idx++;
                newrow.cell = new string[14];  //total number of columns  
                newrow.cell[0] = row[0].ToString();
                newrow.cell[1] = row[1].ToString();
                newrow.cell[2] = row[2].ToString();
                newrow.cell[3] = row[3].ToString();
                newrow.cell[4] = row[4].ToString();
                newrow.cell[5] = row[5].ToString();
                newrow.cell[6] = row[6].ToString();
                newrow.cell[7] = row[7].ToString();
                newrow.cell[8] = row[8].ToString();
                newrow.cell[9] = row[9].ToString();
                newrow.cell[10] = row[10].ToString();
                newrow.cell[11] = row[11].ToString();
                newrow.cell[12] = row[12].ToString();
                newrow.cell[13] = row[13].ToString();
                rowsadded.Add(newrow);
            }
            result.rows = rowsadded.ToArray();
            result.page = page;
            result.total = dt.Rows.Count;
            result.record = rowsadded.Count;
            return result;
        }

    }
}




/* vanhaa



using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace show_inident
{
    public partial class indicentGrid : System.Web.UI.Page
    {
        DataTable dtResult = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["tkuscsm-dwsConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(@"SELECT IncidentDim.Title, 
                                                        IncidentDim.Id, 
                                                        IncidentDim.ClosedDate, 
                                                        IncidentDim.CreatedDate,
                                                        WorkItemDimvw.Id, 
                                                        WorkItemDimvw.WorkItemDimKey, 
                                                        WorkItemAffectedUserFactvw.WorkItemDimKey, 
                                                        WorkItemAffectedUserFactvw.WorkItemAffectedUser_UserDimKey, 
                                                        UserDimvw.UserName, UserDimvw.UserDimKey
                                                        FROM DWRepository.dbo.IncidentDim IncidentDim, 
                                                        DWRepository.dbo.UserDimvw UserDimvw, 
                                                        DWRepository.dbo.WorkItemAffectedUserFactvw WorkItemAffectedUserFactvw, 
                                                        DWRepository.dbo.WorkItemDimvw WorkItemDimvw
                                                        WHERE WorkItemAffectedUserFactvw.WorkItemAffectedUser_UserDimKey = UserDimvw.UserDimKey AND 
                                                        WorkItemAffectedUserFactvw.WorkItemDimKey = WorkItemDimvw.WorkItemDimKey AND 
                                                        IncidentDim.Id = WorkItemDimvw.Id AND ((UserDimvw.UserName='slahdeti'));", connection))
                using (SqlDataReader reader = command.ExecuteReader())
                dtResult.Load(reader);
                GridView1.DataSource = dtResult;
                GridView1.DataBind();
                connection.Close();
            }
        }
    }
}
*/
