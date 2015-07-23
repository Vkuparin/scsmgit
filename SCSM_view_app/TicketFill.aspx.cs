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

public partial class TicketFill : System.Web.UI.Page
{
        private string _userAccountName = Environment.UserName;
        protected string userAccountName { get { return this._userAccountName; } }

        private string _computerName = Environment.MachineName;
        protected string computerName { get { return this._computerName; } }
        
        protected void Page_Load(object sender, EventArgs e)
        {

            PrincipalContext ctx = new PrincipalContext(ContextType.Domain);

            // define a "query-by-example" principal - here, we search for a UserPrincipal 
            UserPrincipal qbeUser = new UserPrincipal(ctx);

            // if you're looking for a particular user - you can limit the search by specifying
            // e.g. a SAMAccountName, a first name - whatever criteria you are looking for
            qbeUser.SamAccountName = userAccountName;

            // create your principal searcher passing in the QBE principal    
            PrincipalSearcher srch = new PrincipalSearcher(qbeUser);

            // find all matches
            foreach (var found in srch.FindAll())
            {
                    
            }

        }

}