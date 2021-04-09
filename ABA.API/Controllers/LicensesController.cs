using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.Application.License.Services;
using ABA.DataTransferObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class LicensesController: ControllerBase
    {
        private readonly ILicenseService _licenseService;

        public LicensesController(ILicenseService licenseService)
        {
            _licenseService = licenseService;
        }

        [HttpGet]
        public async Task<List<LicenseDto>> GetLicenses()
        {
            return new List<LicenseDto>();
        }

        [HttpPost]
        public async Task<int> PostLicense()
        {
            return 0;
        }

        [HttpGet("{licenseId:int}")]
        public async Task<LicenseDto> GetLicense(int licenseId)
        {
            return new LicenseDto();
        }
    }
}