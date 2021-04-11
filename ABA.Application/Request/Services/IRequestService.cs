using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects.Request;
using ABA.Models.Wrappers;

namespace ABA.Application.Request.Services
{
    public interface IRequestService
    {
        PaginatedResponse<List<RequestDto>> GetRequests(RequestFilterDto filter);
        Task<List<RequestStatusDto>> GetStatuses();
        Task<Response<int>> AddRequest(RequestToAddDto request);
        PaginatedResponse<List<RequestDto>> GetUserRequests(RequestFilterDto filter);
        Task<Response<RequestToValidateDto>> GetRequestPreview(int requestId);
    }
}