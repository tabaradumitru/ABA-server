using System.Threading.Tasks;
using ABA.DataTransferObjects.Authentication;
using ABA.Models.Wrappers;

namespace ABA.Application.Authentication.Services
{
    public interface IAuthenticationService
    {
        Task<Response<UserDto>> TwoStepLogin(TwoStepAuthModel loginModel, bool isEmployee);
    }
}