using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects.Request;
using ABA.Models.Wrappers;

namespace ABA.Application.Request.Services
{
    public interface IRequestService
    {
        Task<PaginatedResponse<List<RequestDto>>> GetRequests(RequestFilter requestFilter);
        Task<List<RequestStatusDto>> GetStatuses();
        Task<Response<int>> AddRequest(RequestDto request);
        Task<Response<List<RequestDto>>> GetRequests(string idnp);
        Task<Response<RequestDto>> GetRequestPreview(int requestId);
    }
}