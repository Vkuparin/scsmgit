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
    public partial class incident : System.Web.UI.Page
    {
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

        [WebMethod]
        public static s_GridResult GetIncidentTable(string _search, string nd, int rows, int page, string sidx, string sord)

    }
}

