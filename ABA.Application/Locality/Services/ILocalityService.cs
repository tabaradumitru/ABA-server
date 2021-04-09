using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects;

namespace ABA.Application.Locality.Services
{
    public interface ILocalityService
    {
        Task<List<AreaDto>> GetAllLocalities();
    }
}