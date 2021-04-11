using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects;
using ABA.DataTransferObjects.License;
using ABA.Models.Wrappers;

namespace ABA.Application.License.Services
{
    public interface ILicenseService
    {
        PaginatedResponse<List<LicenseDto>> GetLicenses(LicenseFilterDto filter);
        PaginatedResponse<List<LicenseDto>> GetUserLicenses(LicenseFilterDto filter);
        Task<Response<LicenseDto>> GetLicense(int licenseId);
        Task<Response<LicenseIdDto>> CreateLicense(int requestId, string employeeIdnp);
        Task<List<LicenseStatusDto>> GetLicenseStatuses();
    }
}