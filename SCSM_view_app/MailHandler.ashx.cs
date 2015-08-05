using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Mail;

namespace show_incident
{
    /// <summary>
    /// Summary description for MailHandler
    /// </summary>
    public class MailHandler : IHttpHandler
    {

        //Kolmas yritys mailin lähettämiseen
        public void ProcessRequest(HttpContext context)
        {
            string jsonString = String.Empty;
            HttpContext.Current.Request.InputStream.Position = 0;
            using (System.IO.StreamReader inputStream =
            new System.IO.StreamReader(HttpContext.Current.Request.InputStream))
            {
                jsonString = inputStream.ReadToEnd();
                System.Web.Script.Serialization.JavaScriptSerializer jSerialize =
                    new System.Web.Script.Serialization.JavaScriptSerializer();
                
                var email = jSerialize.Deserialize<Mail>(jsonString);

                if (email != null)
                {
                    string from = email.From;
                    string to = email.To;
                    string subject = email.Subject;
                    string body = email.Body;
                    using (SmtpClient client = new SmtpClient("smtp.turku.fi"))
                    {
                        client.UseDefaultCredentials = false;
                        client.Port = 25;

                        using (MailMessage mail = new MailMessage())
                        {
                            mail.Subject = subject;
                            mail.Body = body;

                            mail.From = new MailAddress(from);
                            mail.To.Add(to);

                            client.Send(mail);
                        }
                    }
                    context.Response.Write(jSerialize.Serialize(
                         new
                         {
                             Response = "Message Has been sent successfully"
                         }));
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}