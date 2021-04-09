using ABA.Application.Authentication.Models;

namespace ABA.Application.Authentication.Services
{
    public interface ITokenService
    {
        string CreateToken(UserData user, string role);
    }
}