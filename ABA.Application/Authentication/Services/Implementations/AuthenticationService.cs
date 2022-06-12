using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using ABA.Application.Authentication.Models;
using ABA.Application.Cryptography.Services;
using ABA.DataTransferObjects.Authentication;
using ABA.Models.Configuration;
using ABA.Models.Constants;
using ABA.Models.Wrappers;
using ABA.Persistence.ABA;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace ABA.Application.Authentication.Services.Implementations
{
    public class AuthenticationService: IAuthenticationService
    {
        private readonly ABADbContext _abaDbContext;
        private readonly AuthorizationConfiguration _authConfig;
        private readonly IEncryptionService _encryptionService;
        private readonly ITokenService _tokenService;

        public AuthenticationService(
            ABADbContext abaDbContext, 
            IOptions<AuthorizationConfiguration> authConfig, 
            IEncryptionService encryptionService, ITokenService tokenService)
        {
            _abaDbContext = abaDbContext;
            _encryptionService = encryptionService;
            _tokenService = tokenService;
            _authConfig = authConfig.Value;
        }

        public async Task<Response<UserDto>> TwoStepLogin(TwoStepAuthModel loginModel, bool isEmployee)
        {
            var response = new Response<UserDto>();

            if (isEmployee)
            {
                var employee = await _abaDbContext.Employees.FindAsync(loginModel.Idnp);
                
                if (employee == null)
                {
                    response.Errors.Add("Utilizatorul nu a putut fi găsit!");
                    response.StatusCode = HttpStatusCode.NotFound;
                    return response;
                }
                
                var dataAfterMPass = new UserData
                {
                    FirstName = employee.FirstName,
                    LastName = employee.LastName,
                    Idnp = employee.EmployeeIdnp
                };

                response.Content = new UserDto
                {
                    Idnp = dataAfterMPass.Idnp,
                    FirstName = dataAfterMPass.FirstName,
                    LastName = dataAfterMPass.LastName,
                    Role = Role.Employee,
                    Token = _tokenService.CreateToken(dataAfterMPass, Role.Employee)
                };
            }
            else
            {
                var citizen = await _abaDbContext.Citizens.FindAsync(loginModel.Idnp);
                
                if (citizen == null)
                {
                    response.Errors.Add("Utilizatorul nu a putut fi găsit!");
                    response.StatusCode = HttpStatusCode.NotFound;
                    return response;
                }
                
                var dataAfterMPass = new UserData
                {
                    FirstName = citizen.FirstName,
                    LastName = citizen.LastName,
                    Idnp = citizen.CitizenIdnp
                };

                response.Content = new UserDto
                {
                    Idnp = dataAfterMPass.Idnp,
                    FirstName = dataAfterMPass.FirstName,
                    LastName = dataAfterMPass.LastName,
                    Role = Role.User,
                    Token = _tokenService.CreateToken(dataAfterMPass, Role.User)
                };
            }

            return response;
        }

        private string GenerateToken(UserData user, string role)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Role, role),
                new Claim(ClaimTypes.GivenName, user.FirstName),
                new Claim(ClaimTypes.Surname, user.LastName),
                new Claim(ClaimTypes.NameIdentifier, user.Idnp)
            };
            
            var securityKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(_authConfig.SecretKey));

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Issuer = _authConfig.Issuer,
                Audience = _authConfig.Audience,
                Expires = DateTime.Now.AddHours(_authConfig.SessionTimeout),
                SigningCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenString = tokenHandler.WriteToken(token);
            
            return tokenString;
        }
    }
}