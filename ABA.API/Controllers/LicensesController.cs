using System.Collections.Generic;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using ABA.Application.License.Services;
using ABA.DataTransferObjects;
using ABA.DataTransferObjects.License;
using ABA.DataTransferObjects.Request;
using ABA.Models.Wrappers;
using ABA.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LicensesController: ControllerBase
    {
        private readonly ILicenseService _licenseService;

        public LicensesController(ILicenseService licenseService)
        {
            _licenseService = licenseService;
        }

        // [HttpPost("send-message")]
        // public async Task SendSMS()
        // {
        //     var smsService = new SmsService();
        //
        //     await smsService.Send(79335566, "Numarul permisului de identificare este PA-000000023! Numarul permisului de identificare este PA-000000023! Numarul permisului de identificare este PA-000000023! Numarul permisului de identificare este PA-000000023!");
        // }

        #region Employee Endpoints

        [Authorize(Roles = "Employee")]
        [HttpGet("all-licenses")]
        public PaginatedResponse<List<LicenseDto>> GetLicenses([FromQuery] LicenseFilterDto filter)
        {
            return _licenseService.GetLicenses(filter);
        }

        [Authorize(Roles = "Employee")]
        [HttpPost]
        public async Task<IActionResult> PostLicense([FromBody] RequestIdDto requestIdDto)
        {
            var idnp = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            var response = await _licenseService.CreateLicense(requestIdDto.RequestId, idnp);
            
            switch (response.StatusCode)
            {
                case HttpStatusCode.BadRequest: return BadRequest(response);
                case HttpStatusCode.InternalServerError: return BadRequest(response);
                case HttpStatusCode.NotFound: return NotFound(response);
                default: return Ok(response.Content);
            }
        }

        #endregion
        
        #region User Endpoints
        
        [Authorize(Roles = "User")]
        [HttpGet]
        public PaginatedResponse<List<LicenseDto>> GetUserLicenses([FromQuery] LicenseFilterDto filter)
        {
            filter.CitizenIdnp = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            return _licenseService.GetUserLicenses(filter);
        }
        
        [Authorize(Roles = "User")]
        [HttpGet("{licenseId:int}")]
        public async Task<IActionResult> GetLicense(int licenseId)
        {
            var response = await _licenseService.GetLicense(licenseId);

            switch (response.StatusCode)
            {
                case HttpStatusCode.BadRequest: return BadRequest(response);
                case HttpStatusCode.InternalServerError: return BadRequest(response);
                case HttpStatusCode.NotFound: return NotFound(response);
                default: return Ok(response.Content);
            }
        }

        #endregion
        
        #region Other Endpoints

        [HttpGet("statuses")]
        public async Task<List<LicenseStatusDto>> GetLicenseStatuses()
        {
            return await _licenseService.GetLicenseStatuses();
        }

        #endregion
    }
}