using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.Application.Locality.Services;
using ABA.DataTransferObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class LocalitiesController: ControllerBase
    {
        private readonly ILocalityService _localityService;

        public LocalitiesController(ILocalityService localityService)
        {
            _localityService = localityService;
        }

        [HttpGet]
        public async Task<List<AreaDto>> GetAllLocalities()
        {
            return await _localityService.GetAllLocalities();
        }

        [HttpGet("areas")]
        public async Task<List<AreaDto>> GetAreas()
        {
            return new List<AreaDto>();
        }

        [HttpGet("districts")]
        public async Task<List<DistrictDto>> GetDistricts()
        {
            return new List<DistrictDto>();
        }
    }
}