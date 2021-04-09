
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using ABA.Application.Authentication.Models;
using ABA.Models.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace ABA.Application.Authentication.Services.Implementations
{
    public class TokenService: ITokenService
    {
        private readonly AuthorizationConfiguration _authConfig;
        private readonly SymmetricSecurityKey _securityKey;

        public TokenService(IOptions<AuthorizationConfiguration> authConfig)
        {
            _authConfig = authConfig.Value;
            _securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_authConfig.SecretKey));
        }

        public string CreateToken(UserData user, string role)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Role, role),
                new Claim(ClaimTypes.NameIdentifier, user.Idnp),
                new Claim(ClaimTypes.GivenName, user.FirstName),
                new Claim(ClaimTypes.Surname, user.LastName)
            };

            var creds = new SigningCredentials(_securityKey, SecurityAlgorithms.HmacSha256);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddMinutes(500),
                SigningCredentials = creds,
                Issuer = _authConfig.Issuer,
                Audience = _authConfig.Audience
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);
            
            return tokenHandler.WriteToken(token);
        }
    }
}