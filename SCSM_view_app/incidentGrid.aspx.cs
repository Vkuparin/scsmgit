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

namespace show_incident
{
    public partial class incidentGrid : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }
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
        [WebMethod]
        public static s_GridResult GetDataTable(string _search, string nd, int rows, int page, string sidx, string sord)
        {

            int startindex = (page - 1);
            int endindex = page;
            string sql = @"SELECT IncidentDim.Title, 
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
                               IncidentDim.Id = WorkItemDimvw.Id AND ((UserDimvw.UserName='slahdeti'));";

            Debug.WriteLine("tällänen teksti"); //Ei näy missään
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
                newrow.cell = new string[10];  //total number of columns  
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