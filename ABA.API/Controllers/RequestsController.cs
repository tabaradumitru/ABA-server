using System.Collections.Generic;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using ABA.Application.Request.Services;
using ABA.DataTransferObjects.Request;
using ABA.Models.Wrappers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class RequestsController: ControllerBase
    {
        private readonly IRequestService _requestService;

        public RequestsController(IRequestService requestService)
        {
            _requestService = requestService;
        }

        #region Employee Endpoints

        [Authorize(Roles = "Employee")]
        [HttpGet("all-requests")]
        public PaginatedResponse<List<RequestDto>> GetRequests([FromQuery] RequestFilterDto filter)
        {
            return _requestService.GetRequests(filter);
        }
        
        [Authorize(Roles = "Employee")]
        [HttpGet("preview/{requestId:int}")]
        public async Task<IActionResult> GetRequest(int requestId)
        {
            var response = await _requestService.GetRequestPreview(requestId);
            
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
        public PaginatedResponse<List<RequestDto>> GetUserRequests([FromQuery] RequestFilterDto filter)
        {
            filter.CitizenIdnp = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            
            return _requestService.GetUserRequests(filter);
        }
        
        [Authorize(Roles = "User")]
        [HttpPost]
        public async Task<IActionResult> CreateRequest(RequestToAddDto request)
        {
            var idnp = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            request.CitizenIdnp = idnp;
            
            var response = await _requestService.AddRequest(request);

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
        public async Task<List<RequestStatusDto>> GetStatuses()
        {
            return await _requestService.GetStatuses();
        }

        #endregion
        
        // [Authorize(Roles = "Employee")]
        // [HttpGet("{idnp}")]
        // public async Task<IActionResult> GetRequests(string idnp)
        // {
        //     var response = await _requestService.GetRequests(idnp);
        //     
        //     switch (response.StatusCode)
        //     {
        //         case HttpStatusCode.BadRequest: return BadRequest(response);
        //         case HttpStatusCode.InternalServerError: return BadRequest(response);
        //         case HttpStatusCode.NotFound: return NotFound(response);
        //         default: return Ok(response.Content);
        //     }
        // }
        
        // [HttpPatch("{requestId:int}/cancel")]
        // public async Task CancelRequest(int requestId)
        // {
        //     return;
        // }
        //
        // [HttpDelete("{requestId:int}")]
        // public async Task DeleteRequest(int requestId)
        // {
        //     return;
        // }
    }
}