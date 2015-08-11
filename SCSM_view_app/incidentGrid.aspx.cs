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
            string user = userFullName;
            Debug.WriteLine(user + " KÄYTTÄJÄN NIMI GRID HAUSSA");
            int startindex = (page - 1);
            int endindex = page;
            string sql = @"SELECT IncidentDim.Id, 
                               IncidentDim.Title,
                               IncidentDim.Description,
                               IncidentDim.ResolutionDescription,
                               IncidentStatusvw.Incidentstatusvalue, 
                               cast (IncidentDim.ClosedDate as date) as ClosedDate, 
                               cast (IncidentDim.CreatedDate as date) as CreatedDate,
                               WorkItemDimvw.Id, 
                               UserDimvw.DisplayName
                               FROM DWRepository.dbo.IncidentDim IncidentDim,
                               DWRepository.dbo.incidentstatusvw as incidentstatusvw, 
                               DWRepository.dbo.UserDimvw UserDimvw, 
                               DWRepository.dbo.WorkItemAffectedUserFactvw WorkItemAffectedUserFactvw, 
                               DWRepository.dbo.WorkItemDimvw WorkItemDimvw
                               WHERE incidentstatusvw.IncidentStatusId = IncidentDim.Status_IncidentStatusId AND
                               WorkItemAffectedUserFactvw.WorkItemAffectedUser_UserDimKey = UserDimvw.UserDimKey AND
                               WorkItemAffectedUserFactvw.WorkItemDimKey = WorkItemDimvw.WorkItemDimKey AND 
                               IncidentDim.Id = WorkItemDimvw.Id AND ((UserDimvw.DisplayName='" + user+"')) ORDER BY IncidentDim.CreatedDate DESC;";


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
                newrow.cell = new string[9];  //total number of columns  
                newrow.cell[0] = row[0].ToString();
                newrow.cell[1] = row[1].ToString();
                newrow.cell[2] = row[2].ToString();
                newrow.cell[3] = row[3].ToString();
                newrow.cell[4] = row[4].ToString();
                newrow.cell[5] = row[5].ToString();
                newrow.cell[6] = row[6].ToString();
                newrow.cell[7] = row[7].ToString();
                newrow.cell[8] = row[8].ToString();
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
