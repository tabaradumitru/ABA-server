using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.Application.ReceivingMethod.Services;
using ABA.DataTransferObjects.ReceivingMethod;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/receiving-methods")]
    public class ReceivingMethodsController: ControllerBase
    {
        private readonly IReceivingMethodService _receivingMethodService;

        public ReceivingMethodsController(IReceivingMethodService receivingMethodService)
        {
            _receivingMethodService = receivingMethodService;
        }

        [HttpGet]
        public async Task<List<ReceivingMethodDto>> GetReceivingMethods()
        {
            return await _receivingMethodService.GetReceivingMethods();
        }
    }
}