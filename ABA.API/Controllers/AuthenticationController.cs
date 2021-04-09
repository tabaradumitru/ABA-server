using System.Threading.Tasks;
using ABA.Application.Authentication.Services;
using ABA.DataTransferObjects.Authentication;
using ABA.Models.Wrappers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthenticationController: ControllerBase
    {
        private readonly IAuthenticationService _authenticationService;

        public AuthenticationController(IAuthenticationService authenticationService)
        {
            _authenticationService = authenticationService;
        }

        [HttpPost("login/two-step-auth")]
        public async Task<Response<UserDto>> TwoStepAuthLogin(TwoStepAuthModel loginModel)
        {
            return await _authenticationService.TwoStepLogin(loginModel, false);
        }
        
        [HttpPost("login/two-step-auth/employee")]
        public async Task<Response<UserDto>> TwoStepAuthLoginEmployee(TwoStepAuthModel loginModel)
        {
            return await _authenticationService.TwoStepLogin(loginModel, true);
        }

        [HttpGet("random")]
        [Authorize]
        public ActionResult<string> GetRandomText()
        {
            return "random text";
        }

        [HttpPost("logout")]
        public async Task Logout()
        {
            return;
        }
    }
}