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
using System.Management;

public partial class TicketFill : System.Web.UI.Page
{
        private string _userAccountName = Environment.UserName;
        protected string userAccountName { get { return this._userAccountName; } }

        private string _computerName = Environment.MachineName;
        protected string computerName { get { return this._computerName; } }

        private string _osName = getOsName() + ", Käyttöjärjestelmän versio: "+Environment.OSVersion.ToString();
        protected string osName { get { return this._osName; } }

        private static string getOsName()
        {
            var name = (from x in new ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem").Get().OfType<ManagementObject>()
                        select x.GetPropertyValue("Caption")).FirstOrDefault();
            return name != null ? name.ToString() : "Unknown";
        }
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

            using (DirectoryEntry de = new DirectoryEntry("LDAP://adturku.fi"))
            {
                using (DirectorySearcher adSearch = new DirectorySearcher(de))
                {
                    adSearch.PropertiesToLoad.Add("sn");  // surname = last name
                    adSearch.PropertiesToLoad.Add("givenName");  // given (or first) name
                    adSearch.PropertiesToLoad.Add("mail");  // e-mail addresse
                    adSearch.PropertiesToLoad.Add("telephoneNumber");  // phone number
                    adSearch.Filter = "(sAMAccountName=" + userAccountName+")";
                    SearchResult adSearchResult = adSearch.FindOne();
                }
            }

        }

}