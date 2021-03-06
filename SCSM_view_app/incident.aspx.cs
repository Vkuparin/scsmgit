﻿using System;
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
    public partial class incident : System.Web.UI.Page
    {
        //Incident id parametri
        public static string v = "";

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
            
           // Read in parameters
           v = Request.QueryString["id"];
           if (v != null){
                parametri.Text = v;
           }
        }
        [WebMethod]
        public static s_GridResult GetIncidentTable(string _search, string nd, int rows, int page, string sidx, string sord)
        {
            int startindex = (page - 1);
            int endindex = page;
            string sql = @"SELECT I.Priority,
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
                                WHERE I.Id = '" + v + "';";

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
                newrow.cell = new string[19];  //total number of columns  
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
                newrow.cell[14] = row[14].ToString();
                newrow.cell[15] = row[15].ToString();
                newrow.cell[16] = row[16].ToString();
                newrow.cell[17] = row[17].ToString();
                newrow.cell[18] = row[18].ToString();
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

/*using System;
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
*/