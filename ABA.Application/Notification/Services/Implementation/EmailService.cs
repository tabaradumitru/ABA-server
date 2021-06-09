using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Text.RegularExpressions;

namespace ABA.Application.Notification.Services.Implementation
{
    public class EmailService
    {
        public string Recipient { get; set; }
        public List<string> CCRecipients { get; set; }
        public List<string> BCCRecipients { get; set; }
        public string MailSubject { get; set; }
        public string MailBody { get; set; }

        public List<Attachment> Attachments { get; set; }
        public List<LinkedResource> LinkedResources { get; set; }
        public MailPriority Priority { get; set; }

        private MailMessage Message { get; }
        private SmtpClient Smtp { get; }

        public EmailService(NetworkCredential credentials = null, MailMessage mailMessage = null, string host = null)
        {
            CCRecipients = new List<string>();
            BCCRecipients = new List<string>();
            Priority = MailPriority.Normal;
            Attachments = new List<Attachment>();
            LinkedResources = new List<LinkedResource>();
            Message = mailMessage ?? new MailMessage()
            {
                Body = MailBody,
                IsBodyHtml = true
            };

            Smtp = new SmtpClient
            {
                Host = host ?? "smtp.gmail.com",
                UseDefaultCredentials = false,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Port = 587,
                Credentials = credentials ?? new NetworkCredential("commuser0@gmail.com", "Fireworks1317!"),
                EnableSsl = true
            };
        }

        private void SetSenderReceiverInfo()
        {
            // Sender
            if (Message.From == null || string.IsNullOrWhiteSpace(Message.From.Address))
            {
                Message.From = new MailAddress("commuser0@gmail.com", "IGPF - Inspectoratul General al Poliției de Frontieră");
            }

            // Recipients
          
            if (Regex.IsMatch(Recipient, @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"))
            {
                Message.To.Add(Recipient);
            }

            // CC Recipients
            foreach (var address in CCRecipients)
            {
                if (Regex.IsMatch(address, @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"))
                {
                    Message.CC.Add(address);
                }
            }

            // BCC Recipients
            foreach (var address in BCCRecipients)
            {
                if (Regex.IsMatch(address, @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"))
                {
                    Message.Bcc.Add(address);
                }
            }
        }

        public void SendMail(bool async = true, bool isBodyHtml = true)
        {
            SetSenderReceiverInfo();

            if (Message.To.Count == 0 && Message.CC.Count == 0 && Message.Bcc.Count == 0)
            {
                return;
            }

            Message.BodyEncoding = Encoding.UTF8;

            var avHtml = AlternateView.CreateAlternateViewFromString(MailBody, null, MediaTypeNames.Text.Html);

            foreach (var attachment in Attachments)
            {
                var disposition = attachment.ContentDisposition;
                disposition.FileName = attachment.ContentType.Name;
                disposition.DispositionType = DispositionTypeNames.Attachment;
                Message.Attachments.Add(attachment);
            }

            foreach (var resource in LinkedResources)
            {
                avHtml.LinkedResources.Add(resource);
            }

            var textBody = "You must use an e-mail client that supports HTML messages";
            var avText = AlternateView.CreateAlternateViewFromString(textBody, null, MediaTypeNames.Text.Plain);

            Message.AlternateViews.Add(avHtml);

            Message.Subject = MailSubject;
            Message.Priority = Priority;

            Message.IsBodyHtml = isBodyHtml;

            try
            {
                if (async)
                {
                    Smtp.SendAsync(Message, null);
                }
                else
                {
                    Smtp.Send(Message);
                }
            }
            catch (Exception e)
            {
                var s = e.Message;
                Console.WriteLine("Error occured while sending email. " + e.Message);
            }
        }
    }
}