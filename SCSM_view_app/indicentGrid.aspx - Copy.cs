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