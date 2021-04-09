namespace ABA.Models.Configuration
{
    public class AuthorizationConfiguration
    {
        public string SecretKey { get; set; }
        public string Audience { get; set; }
        public string Issuer { get; set; }
        public int SessionTimeout { get; set; }
        public string JwtKeyName { get; set; }
    }
}