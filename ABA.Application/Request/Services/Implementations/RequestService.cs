using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using ABA.DataTransferObjects.Request;
using ABA.DataTransferObjects.Validation;
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

        public PaginatedResponse<List<RequestDto>> GetRequests(RequestFilterDto filter)
        {
            var response = new PaginatedResponse<List<RequestDto>>();

            // TODO: check request object

            // create query
            var query = GetRequestsQuery();

            ApplyFilter(ref query, filter);
            ApplyOrderBy(ref query, filter);

            var requests = PagedList<Persistence.ABA.Entities.Request>.ToPagedList(query, filter.Page, filter.PageSize);
            
            // map data correctly
            if (!requests.Any()) return response;
            
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
                    Note = r.Note,
                    NotifyExpiry = r.NotifyExpiry,
                    ReceivingMethods = r.RequestReceivingMethods
                        .Select(rrm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rrm.ReceivingMethodId,
                            ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rrm.ReceivingMethodValue
                        })
                        .ToList(),
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

            return response;
        }

        public async Task<Response<int>> AddRequest(RequestToAddDto request)
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
                NotifyExpiry = request.NotifyExpiry,
                Note = request.Note,
                RequestReceivingMethods = new List<RequestReceivingMethod>
                {
                    new RequestReceivingMethod
                    {
                        ReceivingMethodId = (int)ReceivingMethods.SMS,
                        ReceivingMethodValue = request.Phone
                    }
                }
            };

            if (!string.IsNullOrWhiteSpace(request.Email))
            {
                requestToAdd.RequestReceivingMethods.Add(new RequestReceivingMethod
                {
                    ReceivingMethodId = (int)ReceivingMethods.Email,
                    ReceivingMethodValue = request.Email
                });
            }
            

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

        public PaginatedResponse<List<RequestDto>> GetUserRequests(RequestFilterDto filter)
        {
            var response = new PaginatedResponse<List<RequestDto>>();
            
            if (string.IsNullOrWhiteSpace(filter.CitizenIdnp))
            {
                response.Errors.Add("IDNP-ul nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            var query = GetRequestsQuery();
            
            ApplyFilter(ref query, filter);
            ApplyOrderBy(ref query, filter);
            
            var requests = PagedList<Persistence.ABA.Entities.Request>.ToPagedList(query, filter.Page, filter.PageSize);

            response.Content = requests
                .Select(r => new RequestDto
                {
                    RequestId = r.RequestId,
                    CitizenIdnp = r.CitizenIdnp,
                    ActivityId = r.ActivityId,
                    StartDate = r.StartDate,
                    EndDate = r.EndDate,
                    CreatedAt = r.CreatedAt,
                    StatusId = r.StatusId,
                    Note = r.Note,
                    ReceivingMethods = r.RequestReceivingMethods
                        .Select(rrm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rrm.ReceivingMethodId,
                            ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rrm.ReceivingMethodValue
                        })
                        .ToList(),
                    NotifyExpiry = r.NotifyExpiry,
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

            return response;
        }

        public async Task<Response<RequestToValidateDto>> GetRequestPreview(int requestId)
        {
            var response = new Response<RequestToValidateDto>();

            response.Content = await _abaDbContext.Requests
                .Include(r => r.CitizenIdnpNavigation)
                .Include(r => r.RequestReceivingMethods)
                    .ThenInclude(r => r.ReceivingMethod)
                .Include(r => r.RequestLocalities)
                    .ThenInclude(rl => rl.Locality)
                    .ThenInclude(rl => rl.District)
                    .ThenInclude(rl => rl.Area)
                .Select(r => new RequestToValidateDto
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
                    NotifyExpiry = r.NotifyExpiry,
                    Note = r.Note,
                    ReceivingMethods = r.RequestReceivingMethods
                        .Select(rrm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rrm.ReceivingMethodId,
                            ReceivingMethodName = rrm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rrm.ReceivingMethodValue
                        })
                        .ToList(),
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
                response.Errors.Add("Cererea nu a putut fi găsită!");
                response.StatusCode = HttpStatusCode.NotFound;
                return response;
            }

            var validations = await _abaDbContext.MconnectValidations
                .Include(m => m.ValidationType)
                .Where(m => m.RequestId == requestId)
                .Select(m => new
                {
                    m.ValidationTypeId,
                    m.ValidationType.ValidationTypeName,
                    m.ValidationValue
                })
                .ToListAsync();

            response.Content.MconnectValidations = validations
                .GroupBy(v => new { v.ValidationTypeId, v.ValidationTypeName })
                .Select(v => new MconnectValidationDto
                {
                    ValidationTypeId = v.Key.ValidationTypeId,
                    ValidationTypeName = v.Key.ValidationTypeName,
                    ValidationValues = v.Select(x => x.ValidationValue).ToList()
                })
                .ToList();

            response.StatusCode = HttpStatusCode.OK;
            return response;
        }

        private Response<int> ValidateRequestToAdd(RequestToAddDto request)
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

        private async Task<Response<int>> ValidateDatabaseRequestData(RequestToAddDto request)
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

        private IQueryable<Persistence.ABA.Entities.Request> GetRequestsQuery()
        {
            return _abaDbContext.Requests
                .Include(r => r.CitizenIdnpNavigation)
                .Include(r => r.RequestReceivingMethods)
                    .ThenInclude(rm => rm.ReceivingMethod)
                .Include(r => r.RequestLocalities)
                    .ThenInclude(rl => rl.Locality)
                    .ThenInclude(rl => rl.District)
                    .ThenInclude(rl => rl.Area)
                .AsQueryable();
        }

        private void ApplyFilter(ref IQueryable<Persistence.ABA.Entities.Request> query, RequestFilterDto filter)
        {
            if (!string.IsNullOrWhiteSpace(filter.CitizenIdnp))
                query = query.Where(q => EF.Functions.Like(q.CitizenIdnp, $"%{filter.CitizenIdnp}%"));
        }

        private void ApplyOrderBy(ref IQueryable<Persistence.ABA.Entities.Request> query, RequestFilterDto filter)
        {
            var sortField = filter.SortField ?? string.Empty;

            switch (sortField.Trim().ToLowerInvariant())
            {
                case "activity-name":
                    if (filter.SortOrder == 1)
                        query = query.OrderBy(x => x.Activity.ActivityName);
                    if (filter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.Activity.ActivityName);
                    break;

                case "start-date":
                    if (filter.SortOrder == 1)
                        query = query.OrderBy(x => x.StartDate);
                    if (filter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.StartDate);
                    break;
                    
                case "end-date":
                    if (filter.SortOrder == 1)
                        query = query.OrderBy(x => x.EndDate);
                    if (filter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.EndDate);
                    break;
                
                case "status-name":
                    if (filter.SortOrder == 1)
                        query = query.OrderBy(x => x.Status.StatusName);
                    if (filter.SortOrder == -1)
                        query = query.OrderByDescending(x => x.Status.StatusName);
                    break;
                
                default:
                    query = query.OrderByDescending(x => x.CreatedAt);
                    break;
            }
        }
    }
}