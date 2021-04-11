using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using ABA.DataTransferObjects;
using ABA.DataTransferObjects.License;
using ABA.DataTransferObjects.Request;
using ABA.Models.Constants;
using ABA.Models.Wrappers;
using ABA.Persistence.ABA;
using ABA.Persistence.ABA.Entities;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.License.Services.Implementations
{
    public class LicenseService: ILicenseService
    {
        private readonly ABADbContext _abaDbContext;

        public LicenseService(ABADbContext abaDbContext)
        {
            _abaDbContext = abaDbContext;
        }

        public PaginatedResponse<List<LicenseDto>> GetLicenses(LicenseFilterDto filter)
        {
            var response = new PaginatedResponse<List<LicenseDto>>();

            if (string.IsNullOrWhiteSpace(filter.CitizenIdnp))
            {
                response.Errors.Add("IDNP-ul nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            var query = GetLicenseQuery();
            
            ApplyFilter(ref query, filter);
            ApplyOrderBy(ref query, filter);

            var licenses = PagedList<Persistence.ABA.Entities.License>.ToPagedList(query, filter.Page, filter.PageSize);
            
            response.Content = licenses
                .Select(l => new LicenseDto
                {
                    LicenseId = l.LicenseId,
                    LicenseNumber = l.LicenseNumber,
                    CitizenIdnp = l.CitizenIdnp,
                    FirstName = l.CitizenIdnpNavigation.FirstName,
                    LastName = l.CitizenIdnpNavigation.LastName,
                    ActivityId = l.ActivityId,
                    StartDate = l.StartDate,
                    EndDate = l.EndDate,
                    CreatedAt = l.CreatedAt,
                    StatusId = l.StatusId,
                    Note = l.Note,
                    NotifyExpiry = l.NotifyExpiry,
                    ReceivingMethods = l.LicenseReceivingMethods
                        .Select(rm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rm.ReceivingMethodId,
                            ReceivingMethodName = rm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rm.ReceivingMethodValue
                        })
                        .ToList(),
                    Areas = l.LicenseLocalities
                        .Select(x => x.Locality.District.Area.AreaId)
                        .Distinct()
                        .ToList(),
                    Districts = l.LicenseLocalities
                        .Select(x => x.Locality.District.DistrictId)
                        .Distinct()
                        .ToList(),
                    Localities = l.LicenseLocalities
                        .Select(x => x.LocalityId)
                        .ToList()
                })
                .ToList();

            response.CurrentPage = licenses.CurrentPage;
            response.PageSize = licenses.PageSize;
            response.TotalCount = licenses.TotalCount;
            response.TotalPages = licenses.TotalPages;
            
            return response;
        }

        public PaginatedResponse<List<LicenseDto>> GetUserLicenses(LicenseFilterDto filter)
        {
            var response = new PaginatedResponse<List<LicenseDto>>();

            var query = GetLicenseQuery();
            
            ApplyFilter(ref query, filter);
            ApplyOrderBy(ref query, filter);

            var licenses = PagedList<Persistence.ABA.Entities.License>.ToPagedList(query, filter.Page, filter.PageSize);
            
            response.Content = licenses
                .Select(l => new LicenseDto
                {
                    LicenseId = l.LicenseId,
                    LicenseNumber = l.LicenseNumber,
                    CitizenIdnp = l.CitizenIdnp,
                    FirstName = l.CitizenIdnpNavigation.FirstName,
                    LastName = l.CitizenIdnpNavigation.LastName,
                    ActivityId = l.ActivityId,
                    StartDate = l.StartDate,
                    EndDate = l.EndDate,
                    CreatedAt = l.CreatedAt,
                    StatusId = l.StatusId,
                    Note = l.Note,
                    NotifyExpiry = l.NotifyExpiry,
                    ReceivingMethods = l.LicenseReceivingMethods
                        .Select(rm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rm.ReceivingMethodId,
                            ReceivingMethodName = rm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rm.ReceivingMethodValue
                        })
                        .ToList(),
                    Areas = l.LicenseLocalities
                        .Select(x => x.Locality.District.Area.AreaId)
                        .Distinct()
                        .ToList(),
                    Districts = l.LicenseLocalities
                        .Select(x => x.Locality.District.DistrictId)
                        .Distinct()
                        .ToList(),
                    Localities = l.LicenseLocalities
                        .Select(x => x.LocalityId)
                        .ToList()
                })
                .ToList();

            response.CurrentPage = licenses.CurrentPage;
            response.PageSize = licenses.PageSize;
            response.TotalCount = licenses.TotalCount;
            response.TotalPages = licenses.TotalPages;
            
            return response;
        }

        public async Task<Response<LicenseDto>> GetLicense(int licenseId)
        {
            var response = new Response<LicenseDto>();

            var query = GetLicenseQuery();

            response.Content = await query
                .Select(l => new LicenseDto
                {
                    LicenseId = l.LicenseId,
                    LicenseNumber = l.LicenseNumber,
                    CitizenIdnp = l.CitizenIdnp,
                    FirstName = l.CitizenIdnpNavigation.FirstName,
                    LastName = l.CitizenIdnpNavigation.LastName,
                    ActivityId = l.ActivityId,
                    StartDate = l.StartDate,
                    EndDate = l.EndDate,
                    CreatedAt = l.CreatedAt,
                    StatusId = l.StatusId,
                    Note = l.Note,
                    NotifyExpiry = l.NotifyExpiry,
                    ReceivingMethods = l.LicenseReceivingMethods
                        .Select(rm => new ReceivingMethodDto
                        {
                            ReceivingMethodId = rm.ReceivingMethodId,
                            ReceivingMethodName = rm.ReceivingMethod.ReceivingMethodName,
                            ReceivingMethodValue = rm.ReceivingMethodValue
                        })
                        .ToList(),
                    Areas = l.LicenseLocalities
                        .Select(x => x.Locality.District.Area.AreaId)
                        .ToList(),
                    Districts = l.LicenseLocalities
                        .Select(x => x.Locality.District.DistrictId)
                        .ToList(),
                    Localities = l.LicenseLocalities
                        .Select(x => x.LocalityId)
                        .ToList()
                })
                .FirstOrDefaultAsync(l => l.LicenseId == licenseId);

            if (response.Content == null)
            {
                response.Errors.Add("Permisul nu a putut fi găsit!");
                response.StatusCode = HttpStatusCode.NotFound;
                return response;
            }

            response.Content.Areas = response.Content.Areas.Distinct().ToList();
            response.Content.Districts = response.Content.Districts.Distinct().ToList();

            response.StatusCode = HttpStatusCode.OK;
            return response;
        }
        
        public async Task<Response<LicenseIdDto>> CreateLicense(int requestId, string employeeIdnp)
        {
            var response = new Response<LicenseIdDto>();

            var request = await _abaDbContext.Requests
                .Include(r => r.RequestReceivingMethods)
                .Include(r => r.RequestLocalities)
                    .ThenInclude(rl => rl.Locality)
                    .ThenInclude(rl => rl.District)
                    .ThenInclude(rl => rl.Area)
                .FirstOrDefaultAsync(r => r.RequestId == requestId);

            if (request.StatusId != (int) RequestStatuses.Active)
            {
                response.Errors.Add("Statusul nu este valid!");
                response.StatusCode = HttpStatusCode.BadRequest;
                return response;
            }

            var random = new Random();

            var randomString = random.Next(3, 10000).ToString();

            var license = new Persistence.ABA.Entities.License
            {
                RequestId = request.RequestId,
                EmployeeIdnp = employeeIdnp,
                LicenseNumber = randomString, // TODO: add method that generates a license number
                CreatedAt = DateTime.Now,
                CitizenIdnp = request.CitizenIdnp,
                ActivityId = request.ActivityId,
                StartDate = request.StartDate,
                EndDate = request.EndDate,
                StatusId = (int)LicenseStatuses.Active,
                NotifyExpiry = request.NotifyExpiry,
                LicenseReceivingMethods = request.RequestReceivingMethods
                    .Select(m => new LicenseReceivingMethod
                    {
                        ReceivingMethodId = m.ReceivingMethodId,
                        ReceivingMethodValue = m.ReceivingMethodValue
                    })
                    .ToList(),
                LicenseLocalities = request.RequestLocalities
                    .Select(l => new LicenseLocality
                    {
                        LocalityId = l.LocalityId
                    })
                    .ToList()
            };

            try
            {
                await _abaDbContext.Licenses.AddAsync(license);
                request.StatusId = (int) RequestStatuses.Approved;
                await _abaDbContext.SaveChangesAsync();

                response.Content = new LicenseIdDto
                {
                    LicenseId = license.LicenseId
                };
                response.StatusCode = HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Errors.Add("License could not be created!");
                response.Errors.Add(e.ToString());
                response.StatusCode = HttpStatusCode.InternalServerError;
                return response;
            }
            
            // TODO: Notify user about the license

            return response;
        }

        public async Task<List<LicenseStatusDto>> GetLicenseStatuses()
        {
            return await _abaDbContext.LicenseStatuses
                .Select(s => new LicenseStatusDto
                {
                    StatusId = s.StatusId,
                    StatusName = s.StatusName
                })
                .ToListAsync();
        }

        private IQueryable<Persistence.ABA.Entities.License> GetLicenseQuery()
        {
            return _abaDbContext.Licenses
                .Include(l => l.CitizenIdnpNavigation)
                .Include(l => l.LicenseReceivingMethods)
                    .ThenInclude(ll => ll.ReceivingMethod)
                .Include(l => l.LicenseLocalities)
                    .ThenInclude(ll => ll.Locality)
                    .ThenInclude(ll => ll.District)
                    .ThenInclude(ll => ll.Area)
                .AsQueryable();
        }

        private void ApplyFilter(ref IQueryable<Persistence.ABA.Entities.License> query, LicenseFilterDto filter)
        {
            if (!string.IsNullOrWhiteSpace(filter.CitizenIdnp))
                query = query.Where(q => EF.Functions.Like(q.CitizenIdnp, $"%{filter.CitizenIdnp}%"));
        }

        private void ApplyOrderBy(ref IQueryable<Persistence.ABA.Entities.License> query, LicenseFilterDto filter)
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
                
                default:
                    query = query
                        .OrderBy(x => x.StatusId)
                        .ThenByDescending(x => x.StartDate);
                    break;
            }
        }

    }
}