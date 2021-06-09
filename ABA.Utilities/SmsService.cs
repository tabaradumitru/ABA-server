using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;

namespace ABA.Utilities
{
    public class SmsService
    {
        private long To { get; set; }
        private string From { get; set; }
        public SmsService()
        {
            From = "IGPF";
        }
        public async Task Send(int to, string message)
        {
            To = long.Parse($"373{to}");
            
            var client = new HttpClient();

            var content = new
            {
                content = message,
                from = From,
                to = To
            };
            
            var request = new HttpRequestMessage
            {
                Method = HttpMethod.Post,
                RequestUri = new Uri("https://d7sms.p.rapidapi.com/secure/send"),
                Headers =
                {
                    { "authorization", "Basic cnhtZTI2Mzc6eXlrQ2RGSXM=" },
                    { "x-rapidapi-key", "c78be80087mshd465debf7a6383ep15d08cjsncab34d2b8e57" },
                    { "x-rapidapi-host", "d7sms.p.rapidapi.com" },
                },
                Content = new StringContent(JsonSerializer.Serialize(content))
                {
                    Headers = { ContentType = new MediaTypeHeaderValue("application/json")}
                }
            };
            
            using (var response = await client.SendAsync(request))
            {
                response.EnsureSuccessStatusCode();
                var body = await response.Content.ReadAsStringAsync();
                Console.WriteLine(body);
            }

            //     var client = new HttpClient();
            //     var request = new HttpRequestMessage
            //     {
            //         Method = HttpMethod.Post,
            //         RequestUri = new Uri("https://d7sms.p.rapidapi.com/secure/send"),
            //         Headers =
            //         {
            //             { "authorization", "Basic cnhtZTI2Mzc6eXlrQ2RGSXM=" },
            //             { "x-rapidapi-key", "c78be80087mshd465debf7a6383ep15d08cjsncab34d2b8e57" },
            //             { "x-rapidapi-host", "d7sms.p.rapidapi.com" },
            //         },
            //         Content = new StringContent("{\r
            //             \"content\": \"Test Message\",\r
            //             \"from\": \"D7-Rapid\",\r
            //             \"to\": 37379335566\r
            //     }")
            //     {
            //         Headers =
            //         {
            //             ContentType = new MediaTypeHeaderValue("application/json")
            //         }
            //     }
            // };
            // using (var response = await client.SendAsync(request))
            // {
            //     response.EnsureSuccessStatusCode();
            //     var body = await response.Content.ReadAsStringAsync();
            //     Console.WriteLine(body);
            // }
        }
    }
}