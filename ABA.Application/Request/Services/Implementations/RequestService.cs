using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using ABA.DataTransferObjects.Request;
using ABA.Models.Constants;
using ABA.Models.Wrappers;
using ABA.Persistence.ABA;
using ABA.Persistence.ABA.Entities;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.Request.Services.Implementations
{
    public class RequestService: IRequestService
    {
        private readonly ABADbContext _abaDbContext;

        public RequestService(ABADbContext abaDbContext)
        {
            _abaDbContext = abaDbContext;
        }

        #region Statuses

        public async Task<List<RequestStatusDto>> GetStatuses()
        {
            return await _abaDbContext.RequestStatuses
                .Select(s => new RequestStatusDto
                {
                    StatusId = s.StatusId,
                    StatusName = s.StatusName
                })
                .ToListAsync();
        }

        #endregion

        #region Get Requests

        public async Task<PaginatedResponse<List<RequestDto>>> GetRequests(RequestFilter requestFilter)
        {
            var response = new PaginatedResponse<List<RequestDto>>();

            // TODO: check request object

            // create query
            var query = _abaDbContext.Requests
                .Include(r => r.CitizenIdnpNavigation)
                .Include(r => r.RequestReceivingMethods)
                    .ThenInclude(r => r.ReceivingMethod)
                .Include(r => r.RequestLocalities)
                    .ThenInclude(rl => rl.Locality)
                    .ThenInclude(rl => rl.District)
                    .ThenInclude(rl => rl.Area)
                .AsQueryable();

            ApplyFilter(ref query, requestFilter);
            ApplyOrderBy(ref query, requestFilter);

            // get data as .ToPagedList
            var requests = PagedList<Persistence.ABA.Entities.Request>.ToPagedList(query, requestFilter.Page, requestFilter.PageSize);
            
            // map data correctly
            if (requests.Any())
            {
                response.Content = requests
                    .Select(r => new RequestDto
                    {
                        RequestId = r.RequestId,
                        CitizenIdnp = r.CitizenIdnp,
                        FirstName = r.CitizenIdnpNavigation.FirstName,
                        LastName = r.CitizenIdnpNavigation.LastName,
                        ActivityId = r.ActivityId,
                        StartDate = r.StartDate,
                        EndDate = r.EndDate,
                        CreatedAt = r.CreatedAt,
                        StatusId = r.StatusId,
                        Phone = r.Phone,
                        Note = r.Note,
                        ReceivingMethods = r.RequestReceivingMethods
                            .Select(rrm => new ReceivingMethodDto
                            {
                                ReceivingMethodId = rrm.ReceivingMethodId,
                                ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                                ReceivingMethodValue = rrm.ReceivingMethodValue
                            })
                            .ToList(),
                        NotifyExpiry = false,
                        Areas = r.RequestLocalities
                            .Select(l => l.Locality.District.Area.AreaId)
                            .Distinct()
                            .ToList(),
                        Districts = r.RequestLocalities
                            .Select(l => l.Locality.District.DistrictId)
                            .Distinct()
                            .ToList(),
                        Localities = r.RequestLocalities
                            .Select(l => l.LocalityId)
                            .ToList()
                    })
                    .ToList();
                response.CurrentPage = requests.CurrentPage;
                response.PageSize = requests.PageSize;
                response.TotalCount = requests.TotalCount;
                response.TotalPages = requests.TotalPages;
            }
            
            return response;
        }

        #endregion

        #region Add Request

        public async Task<Response<int>> AddRequest(RequestDto request)
        {
            // TODO: validate user data in mConnect

            var response = ValidateRequestToAdd(request);
            if (response.Errors.Any()) return response;

            response = await ValidateDatabaseRequestData(request);
            if (response.Errors.Any()) return response;

            var requestToAdd = new Persistence.ABA.Entities.Request
            {
                CitizenIdnp = request.CitizenIdnp,
                ActivityId = request.ActivityId,
                StartDate = request.StartDate,
                EndDate = request.EndDate,
                CreatedAt = DateTime.Now,
                StatusId = (int)RequestStatuses.Active,
                Phone = request.Phone,
                Note = request.Note
            };

            var requestLocalities = request.Localities
                .Select(l => new RequestLocality
                {
                    Request = requestToAdd,
                    LocalityId = l
                })
                .ToList();

            await _abaDbContext.Requests.AddAsync(requestToAdd);
            await _abaDbContext.RequestLocalities.AddRangeAsync(requestLocalities);

            try
            {
                await _abaDbContext.SaveChangesAsync();
                response.StatusCode = HttpStatusCode.OK;
                response.Content = requestToAdd.RequestId;
            }
            catch(Exception e)
            {
                response.Errors.Add(e.ToString());
                response.StatusCode = HttpStatusCode.BadRequest;
            }
            
            return response;
        }

        #endregion

        #region Get Requests

        public async Task<Response<List<RequestDto>>> GetRequests(string idnp)
        {
            var response = new Response<List<RequestDto>>();

            if (string.IsNullOrWhiteSpace(idnp))
            {
                response.Errors.Add("IDNP-ul nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            var citizen = await _abaDbContext.Citizens
                .Include(c => c.Requests)
                .ThenInclude(c => c.RequestLocalities)
                .ThenInclude(c => c.Locality)
                .ThenInclude(c => c.District)
                .ThenInclude(c => c.Area)
                .Include(c => c.Requests)
                    .ThenInclude(c => c.RequestReceivingMethods)
                    .ThenInclude(c => c.ReceivingMethod)
                .FirstOrDefaultAsync(c => EF.Functions.Like(c.CitizenIdnp, idnp));

            if (citizen == null)
            {
                response.Errors.Add("IDNP-ul nu a fost găsit!");
                response.StatusCode = HttpStatusCode.NotFound;
                return response;
            }

            response.Content = citizen.Requests
                .Select(r => new RequestDto
                {
                    RequestId = r.RequestId,
                    CitizenIdnp = r.CitizenIdnp,
                    ActivityId = r.ActivityId,
                    StartDate = r.StartDate,
                    EndDate = r.EndDate,
                    CreatedAt = r.CreatedAt,
                    StatusId = r.StatusId,
                    Phone = r.Phone,
                    Note = r.Note,
                    ReceivingMethods = r.RequestReceivingMethods
                        .Select(rrm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rrm.ReceivingMethodId,
                            ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rrm.ReceivingMethodValue
                        })
                        .ToList(),
                    NotifyExpiry = false,
                    Areas = r.RequestLocalities
                        .Select(l => l.Locality.District.Area.AreaId)
                        .Distinct()
                        .ToList(),
                    Districts = r.RequestLocalities
                        .Select(l => l.Locality.District.DistrictId)
                        .Distinct()
                        .ToList(),
                    Localities = r.RequestLocalities
                        .Select(l => l.LocalityId)
                        .ToList()
                })
                .OrderByDescending(r => r.CreatedAt)
                .ToList();
            response.StatusCode = HttpStatusCode.OK;

            return response;
        }

        #endregion

        public async Task<Response<RequestDto>> GetRequestPreview(int requestId)
        {
            var response = new Response<RequestDto>();

            response.Content = await _abaDbContext.Requests
                .Include(r => r.CitizenIdnpNavigation)
                .Include(r => r.RequestReceivingMethods)
                    .ThenInclude(r => r.ReceivingMethod)
                .Include(r => r.RequestLocalities)
                    .ThenInclude(rl => rl.Locality)
                    .ThenInclude(rl => rl.District)
                    .ThenInclude(rl => rl.Area)
                .Select(r => new RequestDto
                {
                    RequestId = r.RequestId,
                    CitizenIdnp = r.CitizenIdnp,
                    FirstName = r.CitizenIdnpNavigation.FirstName,
                    LastName = r.CitizenIdnpNavigation.LastName,
                    ActivityId = r.ActivityId,
                    StartDate = r.StartDate,
                    EndDate = r.EndDate,
                    CreatedAt = r.CreatedAt,
                    StatusId = r.StatusId,
                    Phone = r.Phone,
                    Note = r.Note,
                    ReceivingMethods = r.RequestReceivingMethods
                        .Select(rrm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rrm.ReceivingMethodId,
                            ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rrm.ReceivingMethodValue
                        })
                        .ToList(),
                    NotifyExpiry = false,
                    Areas = r.RequestLocalities
                        .Select(l => l.Locality.District.Area.AreaId)
                        .ToList(),
                    Districts = r.RequestLocalities
                        .Select(l => l.Locality.District.DistrictId)
                        .ToList(),
                    Localities = r.RequestLocalities
                        .Select(l => l.LocalityId)
                        .ToList()
                })
                .FirstOrDefaultAsync(r => r.RequestId == requestId);

            if (response.Content == null)
            {
                response.Errors.Add("Request could not be found!");
                response.StatusCode = HttpStatusCode.NotFound;
                return response;
            }

            response.StatusCode = HttpStatusCode.OK;
            return response;
        }

        private Response<int> ValidateRequestToAdd(RequestDto request)
        {
            var response = new Response<int>();

            if (request == null)
            {
                response.Errors.Add("Cererea nu este validă!");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            if (string.IsNullOrWhiteSpace(request.CitizenIdnp))
            {
                response.Errors.Add("IDNP-ul nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            if (string.IsNullOrWhiteSpace(request.Phone))
            {
                response.Errors.Add("Numărul de telefon nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }
            else if (request.Phone.Length > 9)
            {
                response.Errors.Add("Numărul de telefon poate avea maxim 9 cifre!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }
            
            if (request.StartDate == DateTime.MinValue)
            {
                response.Errors.Add("Data de început nu este validă");
                response.StatusCode = HttpStatusCode.BadRequest;
            }
            
            if (request.EndDate == DateTime.MinValue)
            {
                response.Errors.Add("Data de sfârșit nu este validă");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            if (!request.ReceivingMethods.Any())
            {
                response.Errors.Add("Nu ați specificat nici o metodă de primire a permisului!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            if (!request.PersonalDataAgreement)
            {
                response.Errors.Add("Nu sunteți de acord cu prelucrarea datelor personale!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            if (!request.ObeyLawAgreement)
            {
                response.Errors.Add("Nu sunteți de acord cu respectarea legislației în vigoare!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }
            
            if (!request.Localities.Any())
            {
                response.Errors.Add("Nu ați specificat nici o localitate!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            return response;
        }

        public async Task<Response<int>> ValidateDatabaseRequestData(RequestDto request)
        {
            var response = new Response<int>();

            var citizen = await _abaDbContext.Citizens.FindAsync(request.CitizenIdnp);
            if (citizen == null)
            {
                response.Errors.Add("Cetățeanul nu a putut fi găsit");
                response.StatusCode = HttpStatusCode.NotFound;
            }

            var activity = await _abaDbContext.Activities.FindAsync(request.ActivityId);
            if (activity == null)
            {
                response.Errors.Add("Activitatea nu este validă");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            var localities = await _abaDbContext.Localities
                .Where(l => request.Localities.Contains(l.LocalityId))
                .ToListAsync();

            if (localities == null || localities.Count != request.Localities.Count)
            {
                response.Errors.Add("Localitățile nu sunt valide!");
                response.StatusCode = HttpStatusCode.BadRequest;
            }

            return response;
        }

        private void ApplyFilter(ref IQueryable<Persistence.ABA.Entities.Request> query, RequestFilter requestFilter)
        {
            
        }

        private void ApplyOrderBy(ref IQueryable<Persistence.ABA.Entities.Request> query, RequestFilter requestFilter)
        {
            var orderBy = requestFilter.SortField ?? string.Empty;

            switch (orderBy.Trim().ToLowerInvariant())
            {
                case "activity-name":
                    if (requestFilter.SortOrder == 1)
                        query = query.OrderBy(x => x.Activity.ActivityName);
                    if (requestFilter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.Activity.ActivityName);
                    break;
                
                case "phone":
                    if (requestFilter.SortOrder == 1)
                        query = query.OrderBy(x => x.Phone);
                    if (requestFilter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.Phone);
                    break;
                
                case "start-date":
                    if (requestFilter.SortOrder == 1)
                        query = query.OrderBy(x => x.StartDate);
                    if (requestFilter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.StartDate);
                    break;
                    
                case "end-date":
                    if (requestFilter.SortOrder == 1)
                        query = query.OrderBy(x => x.EndDate);
                    if (requestFilter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.EndDate);
                    break;
                
                case "status-name":
                    if (requestFilter.SortOrder == 1)
                        query = query.OrderBy(x => x.Status.StatusName);
                    if (requestFilter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.Status.StatusName);
                    break;
                
                default:
                    query = query.OrderByDescending(x => x.CreatedAt);
                    break;
            }
        }
    }
}