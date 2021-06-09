using System.Threading.Tasks;
using ABA.Application.License.Services;

namespace ABA.BackgroundJobs.RecurrentJobs.Jobs
{
    public class UpdateLicensesStatuses
    {
        private readonly ILicenseService _licenseService;

        public UpdateLicensesStatuses(ILicenseService licenseService)
        {
            _licenseService = licenseService;
        }

        public async Task Start()
        {
            await _licenseService.UpdateLicensesStatuses();
        }
    }
}