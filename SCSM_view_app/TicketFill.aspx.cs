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
using System.Net;
using System.Net.Mail;



public partial class TicketFill : System.Web.UI.Page
{
        private string _userAccountName = Environment.UserName;
        protected string userAccountName { get { return this._userAccountName; } }

        private string _computerName = Environment.MachineName;
        protected string computerName { get { return this._computerName; } }

        private string _testi = "";
        protected string testi { get { return this._testi; } }

        private string _osName = getOsName() + ", Käyttöjärjestelmän versio: "+Environment.OSVersion.ToString();
        protected string osName { get { return this._osName; } }

        private string[] _userInfoAD = null;
        protected string userFullName { get { return this._userInfoAD[0]; }}
        protected string userEmail { get { return this._userInfoAD[1]; } }
        protected string userPhone { get { return this._userInfoAD[2]; } }
        protected string userCompany { get { return this._userInfoAD[3]; } }
        protected string userDepartment { get { return this._userInfoAD[4]; } }
        protected string userOffice { get { return this._userInfoAD[5]; } }
        protected string userCity { get { return this._userInfoAD[6]; } }

        private static string getOsName()
        {
            var name = (from x in new ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem").Get().OfType<ManagementObject>()
                        select x.GetPropertyValue("Caption")).FirstOrDefault();
            return name != null ? name.ToString() : "Unknown";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            using (DirectoryEntry de = new DirectoryEntry("LDAP://adturku.fi"))
            {
                using (DirectorySearcher adSearch = new DirectorySearcher(de))
                {
                    adSearch.PropertiesToLoad.Add("cn");  // Kokonimi
                    adSearch.PropertiesToLoad.Add("mail");  // Sähköposti
                    adSearch.PropertiesToLoad.Add("telephoneNumber");  // Puhelinnumero
                    //adSearch.PropertiesToLoad.Add("Company");  // Toimiala
                    //adSearch.PropertiesToLoad.Add("Department");  // Yksikkö
                    adSearch.PropertiesToLoad.Add("streetaddress");  // Toimipiste
                    //adSearch.PropertiesToLoad.Add("City");  // kaupunki
                    adSearch.Filter = "(sAMAccountName="+ userAccountName+")"; //haku käyttäjänimellä
                    SearchResult adSearchResult = adSearch.FindOne();
                    var searchPropCollection = adSearchResult.Properties;
                    string[] info = new string[15];
                    int infoRivi = 0;
                    foreach (string tulos in searchPropCollection.PropertyNames)
                    {

                        _testi += tulos + " | ";
                        if (tulos.Equals("cn"))
                        {
                            infoRivi = 0;
                        }
                        if (tulos.Equals("mail"))
                        {
                            infoRivi = 1;
                        }
                        if (tulos.Equals("telephonenumber"))
                        {
                            infoRivi = 2;
                        }
                        if (tulos.Equals("company"))
                        {
                            infoRivi = 3;
                        }
                        if (tulos.Equals("department"))
                        {
                            infoRivi = 4;
                        }
                        if (tulos.Equals("streetaddress"))
                        {
                            infoRivi = 5;
                        }
                        
                        foreach (Object myCollection in searchPropCollection[tulos])
                        {
                            info[infoRivi] = myCollection.ToString();
                        }
                    }
                    _userInfoAD = info;
                }
            }

            using (DirectoryEntry de = new DirectoryEntry("LDAP://adturku.fi"))
            {
                using (DirectorySearcher adSearch = new DirectorySearcher(de))
                {
                    //adSearch.PropertiesToLoad.Add("telephoneNumber");  // Puhelinnumero
                    adSearch.PropertiesToLoad.Add("Company");  // Toimiala
                    adSearch.PropertiesToLoad.Add("Department");  // Yksikkö
                    //adSearch.PropertiesToLoad.Add("Office");  // Toimipiste
                    //adSearch.PropertiesToLoad.Add("City");  // kaupunki
                    adSearch.Filter = "(sAMAccountName=kkolima)"; //+ userAccountName+
                    SearchResult adSearchResult = adSearch.FindOne();
                    var searchPropCollection = adSearchResult.Properties;
                    string[] info = new string[15];
                    int infoRivi = 0;
                    foreach (string tulos in searchPropCollection.PropertyNames)
                    {


                        if (tulos.Equals("telephonenumber"))
                        {
                            infoRivi = 2;
                        }
                        if (tulos.Equals("company"))
                        {
                            infoRivi = 3;
                        }
                        if (tulos.Equals("department"))
                        {
                            infoRivi = 4;
                        }

                        foreach (Object myCollection in searchPropCollection[tulos])
                        {
                            info[infoRivi] = myCollection.ToString();
                        }
                    }
                    _userInfoAD[3] = info[3];
                    _userInfoAD[4] = info[4];
                }
            }

        }
        protected void SendButton_Click(Object sender, EventArgs e)            
        {
            
            MailMessage mail = new MailMessage("noreply@turku.fi", "ville.kuparinen@turku.fi"); //lähettäjä, vastaanottaja
            SmtpClient client = new SmtpClient();
            client.Host = "smtp.turku.fi";
            client.Port = 25;
            client.UseDefaultCredentials = false;
            client.EnableSsl = false;
            client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
            mail.Subject = "this is a test email.";
            mail.Body = "this is my test email body"; //maildata, tässä testissä ei vielä anneta parametreja vaan läheteään valmis testi maili
            client.Send(mail);
            Debug.Write("MAIL LÄHETETTY!!");
        }


}