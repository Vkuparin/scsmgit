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
    public partial class incident : System.Web.UI.Page
    {

        private DataTable PivotTable(DataTable origTable)
        {

            DataTable newTable = new DataTable();
            DataRow dr = null;
            //Add Columns to new Table
            for (int i = 0; i <= origTable.Rows.Count; i++)
            {
                newTable.Columns.Add(new DataColumn(origTable.Columns[i].ColumnName, typeof(String)));
            }

            //Execute the Pivot Method
            for (int cols = 0; cols < origTable.Columns.Count; cols++)
            {
                dr = newTable.NewRow();
                for (int rows = 0; rows < origTable.Rows.Count; rows++)
                {
                    if (rows < origTable.Columns.Count)
                    {
                        dr[0] = origTable.Columns[cols].ColumnName; // Add the Column Name in the first Column
                        dr[rows + 1] = origTable.Rows[rows][cols];
                    }
                }
                newTable.Rows.Add(dr); //add the DataRow to the new Table rows collection
            }
            return newTable;
        }

        DataTable dtResult = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            
           // Read in parameters
            string v = Request.QueryString["id"];
            if (v != null)
            {
                parametri.Text = v;
                // OPEN SQL connection to database
                using (SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["tkuscsm-dwsConnectionString"].ConnectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand(@" SELECT
                                                            I.Priority,
                                                            I.ClosedDate,
                                                            I.InsertedBatchId,
                                                            I.Id as incidentId,
                                                            I.Title,
                                                            I.Description,
                                                            I.CreatedDate,
                                                            month(I.CreatedDate) as slahdeti_month,
                                                            day(I.CreatedDate) as slahdeti_day,
                                                            year(I.CreatedDate) as slahdeti_year,
                                                            I.FirstAssignedDate,
                                                            I.DisplayName as ticket_DisplayName,
                                                            I.IsDeleted,
                                                         itq.IncidentTierQueuesValue,
                                                         ISt.IncidentStatusValue,
                                                         IU.IncidentUrgencyValue,
                                                         II.IncidentImpactValue,
                                                         IC.IncidentClassificationValue,
                                                         ISo.IncidentSourceValue
                                                        FROM DWRepository.dbo.IncidentDim as I
                                                        INNER JOIN DWRepository.dbo.IncidentTierQueuesvw as ITQ on itq.ID = I.TierQueue
                                                        INNER JOIN DWRepository.dbo.IncidentStatusvw as ISt on ISt.ID = I.Status
                                                        INNER JOIN DWRepository.dbo.IncidentUrgencyvw as IU on IU.ID = I.Urgency
                                                        INNER JOIN DWRepository.dbo.IncidentImpactvw as II on II.ID = I.Impact
                                                        INNER JOIN DWRepository.dbo.IncidentClassificationvw as IC on IC.ID = I.Classification
                                                        INNER JOIN DWRepository.dbo.IncidentSourcevw as ISo on Iso.ID = I.Source
                                                                WHERE I.Id = '" + v + "';", connection))
                    using (SqlDataReader reader = command.ExecuteReader())
                    dtResult.Load(reader);
                    DataTable pivotedTable = PivotTable(dtResult);
                    GridView1.DataSource = pivotedTable;
                    GridView1.DataBind();
                    connection.Close();
                }
            }
            else
            {
                palautus.Text = "No incident specified.";
            }
        }
    }
}