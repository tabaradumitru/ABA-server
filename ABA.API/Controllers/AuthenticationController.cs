using System.Net;
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
        public async Task<IActionResult> TwoStepAuthLogin(TwoStepAuthModel loginModel)
        {
            var response = await _authenticationService.TwoStepLogin(loginModel, false);
            
            switch (response.StatusCode)
            {
                case HttpStatusCode.BadRequest: return BadRequest(response);
                case HttpStatusCode.InternalServerError: return BadRequest(response);
                case HttpStatusCode.NotFound: return NotFound(response);
                default: return Ok(response.Content);
            }
        }
        
        [HttpPost("login/two-step-auth/employee")]
        public async Task<IActionResult> TwoStepAuthLoginEmployee(TwoStepAuthModel loginModel)
        {
            var response = await _authenticationService.TwoStepLogin(loginModel, true);
            
            switch (response.StatusCode)
            {
                case HttpStatusCode.BadRequest: return BadRequest(response);
                case HttpStatusCode.InternalServerError: return BadRequest(response);
                case HttpStatusCode.NotFound: return NotFound(response);
                default: return Ok(response.Content);
            }
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