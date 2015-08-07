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
using System.Windows.Forms;
using System.IO;



public partial class TicketFill : System.Web.UI.Page
{

        private string _computerName = null;
       protected string computerName { get { return this._computerName; } }

        /*private string _osName = getOsName() + ", Käyttöjärjestelmän versio: "+Environment.OSVersion.ToString();
        protected string osName { get { return this._osName; } }*/

        private string[] _userInfoAD = null;
        protected string userFullName { get { return this._userInfoAD[0]; }}
        protected string userEmail { get { return this._userInfoAD[1]; } }
        protected string userPhone { get { return this._userInfoAD[2]; } }
        protected string userCompany { get { return this._userInfoAD[3]; } }
        protected string userDepartment { get { return this._userInfoAD[4]; } }
        protected string userOffice { get { return this._userInfoAD[5]; } }
        protected string userCity { get { return this._userInfoAD[6]; } }

        /*private static string getOsName()
        {
            var name = (from x in new ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem").Get().OfType<ManagementObject>()
                        select x.GetPropertyValue("Caption")).FirstOrDefault();
            return name != null ? name.ToString() : "Unknown";
        }*/
        protected void Page_Load(object sender, EventArgs e)
        {
            string userAccountName = User.Identity.Name.ToString().Substring(8);

            string[] computer_name = System.Net.Dns.GetHostEntry(Request.ServerVariables["remote_addr"]).HostName.Split(new Char[] { '.' });
            String ecn = System.Environment.MachineName;
            _computerName = computer_name[0].ToString();

            using (DirectoryEntry de = new DirectoryEntry("LDAP://adturku.fi"))
            {
                using (DirectorySearcher adSearch = new DirectorySearcher(de))
                {
                    adSearch.PropertiesToLoad.Add("cn");  // Kokonimi
                    adSearch.PropertiesToLoad.Add("mail");  // Sähköposti
                    adSearch.PropertiesToLoad.Add("telephoneNumber");  // Puhelinnumero
                    adSearch.PropertiesToLoad.Add("Company");  // Toimiala
                    adSearch.PropertiesToLoad.Add("Department");  // Yksikkö
                    adSearch.PropertiesToLoad.Add("streetaddress");  // Toimipiste
                    //adSearch.PropertiesToLoad.Add("City");  // kaupunki
                    adSearch.Filter = "(sAMAccountName="+ userAccountName+")"; //haku käyttäjänimellä
                    SearchResult adSearchResult = adSearch.FindOne();
                    var searchPropCollection = adSearchResult.Properties;
                    string[] info = new string[15];
                    int infoRivi = 0;
                    foreach (string tulos in searchPropCollection.PropertyNames)
                    {
                        Debug.WriteLine(tulos);
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
                        if (tulos.Equals("adspath"))
                        {
                            continue;
                        }
                        
                        foreach (Object myCollection in searchPropCollection[tulos])
                        {
                            Debug.WriteLine("tokan kerra tulos = " + tulos);
                            Debug.WriteLine("mycollection.tostring = " + myCollection.ToString());
                            info[infoRivi] = myCollection.ToString();
                            Debug.WriteLine("info[inforivi] = " + info[infoRivi]);
                        }
                    }
                    _userInfoAD = info;
                }
            }
           
            //Asetetaan käyttäjän sähköposti täältä koodin puolelta paikalleen, koska emailin lähetyksessä käytetään
            //asp net tekstikenttää, joka saattaa saada uuden arvon lomaketta täytettäessä
            sähköposti.Text = userEmail;
            //Muuttaan dropdown-listan testiosoite käyttäjän omaksi emailiksi
            testiosoite.Value = userEmail;
        }

        protected void SendButton_Click(Object sender, EventArgs e)            
        {
            string from = sähköposti.Text;
            string to = tukiryhmä.SelectedValue;
            string otsikko = ongelmaotsikko.Text;
            
            MailMessage mail = new MailMessage(from, to); //lähettäjä, vastaanottaja
            SmtpClient client = new SmtpClient();
            client.Host = "smtp.turku.fi";
            client.Port = 25;
            client.UseDefaultCredentials = false;
            client.EnableSsl = false;
            client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
            mail.Subject = otsikko;
            //Liite
            Debug.WriteLine("PAINETTU LÄHETYSNAPPIA");
            if (liite1.HasFiles){
                liite1teksti.Text += ("Liitteet: \n");
                foreach (HttpPostedFile uploadedFile in liite1.PostedFiles)
                {
                    string FileName = Path.GetFileName(uploadedFile.FileName);
                    liite1teksti.Text += (FileName + "\n");
                    mail.Attachments.Add(new Attachment(uploadedFile.InputStream, FileName));
                    Debug.WriteLine("LISÄTTY TIEDOSTONIMI " + FileName + " MAILIIN LIITTEEKSI");
                }
                koonti.InnerText += liite1teksti.Text;
            }
            //Luodaan viestin body vasta täällä, koska siihen tehdään mahdollisia lisäyksiä (liitteet) edellä
            string viesti = koonti.InnerText;
            mail.Body = viesti;
            client.Send(mail);
            Debug.WriteLine("MAIL LÄHETETTY!!");
    }

}