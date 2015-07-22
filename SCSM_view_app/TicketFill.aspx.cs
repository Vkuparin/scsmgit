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

public partial class TicketFill : System.Web.UI.Page {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            
          
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Label1.Text = "Clicked at " + DateTime.Now.ToString();
        }
}