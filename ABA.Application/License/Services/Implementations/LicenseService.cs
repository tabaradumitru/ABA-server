using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using ABA.Application.Locality.Services;
using ABA.Application.Notification.Services.Implementation;
using ABA.DataTransferObjects;
using ABA.DataTransferObjects.License;
using ABA.DataTransferObjects.Request;
using ABA.Models.Constants;
using ABA.Models.Wrappers;
using ABA.Persistence.ABA;
using ABA.Persistence.ABA.Entities;
using ABA.Utilities;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.License.Services.Implementations
{
    public class LicenseService: ILicenseService
    {
        private readonly ABADbContext _abaDbContext;
        private readonly ILocalityService _localityService;

        public LicenseService(ABADbContext abaDbContext, ILocalityService localityService)
        {
            _abaDbContext = abaDbContext;
            _localityService = localityService;
        }

        public PaginatedResponse<List<LicenseDto>> GetLicenses(LicenseFilterDto filter)
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
                        .Select(rm => new MappedReceivingMethodDto
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
                        .Select(rm => new MappedReceivingMethodDto
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
                        .Select(rm => new MappedReceivingMethodDto
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
            
            var license = new Persistence.ABA.Entities.License
            {
                RequestId = request.RequestId,
                EmployeeIdnp = employeeIdnp,
                LicenseNumber = await GetNextLicenseNumber(),
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
            
            #region Send Email to the User

            var email = request.RequestReceivingMethods
                .Where(rm => rm.ReceivingMethodId == (int) ReceivingMethods.Email)
                .Select(rm => rm.ReceivingMethodValue)
                .FirstOrDefault();
            
            var phoneNumber = request.RequestReceivingMethods
                .Where(rm => rm.ReceivingMethodId == (int) ReceivingMethods.SMS)
                .Select(rm => rm.ReceivingMethodValue)
                .FirstOrDefault();
            
            var allLocalities = await _localityService.GetAllLocalities();
            
            var areas = allLocalities
                .Where(a => request.RequestLocalities.Select(rl => rl.Locality.District.Area.AreaId).Distinct().ToList().Contains(a.AreaId))
                .Select(a => new
                {
                    a.AreaId,
                    a.AreaName,
                    Districts = a.Districts
                        .Where(d => request.RequestLocalities.Select(rl => rl.Locality.District.DistrictId).Distinct().ToList().Contains(d.DistrictId))
                        .Select(d => new
                        {
                            d.DistrictId,
                            d.DistrictName,
                            Localities = d.Localities
                                .Where(l => request.RequestLocalities.Select(rl => rl.Locality.LocalityId).Distinct().ToList().Contains(l.LocalityId))
                                .Select(l => new
                                {
                                    l.LocalityId,
                                    l.LocalityName
                                })
                                .ToList()
                        })
                        .ToList()
                })
                .ToList();
            
            var activity = await _abaDbContext.Activities.FirstOrDefaultAsync(a => a.ActivityId == license.ActivityId);

            if (!string.IsNullOrWhiteSpace(phoneNumber))
            {
                var smsService = new SmsService();

                var message = $"Buna! Cererea depusa de dumneavoastra pentru obtinerea permisului de acces in zona de frontiera a fost aprobata cu succes. Numarul de identificare: {license.LicenseNumber}; Scopul: {activity.ActivityName}; Perioada: {license.StartDate:dd/MM/yyyy} - {license.EndDate:dd/MM/yyyy}; Va rugam ca in timpul aflarii in zona de frontiera sa detineti cel putin numarul de identificare al permisului la dumneavoastra.";
                
                await smsService.Send(int.Parse(phoneNumber), message);
            }

            if (!string.IsNullOrWhiteSpace(email))
            {
                var emailService = new EmailService();


                var content = "";

                foreach (var area in areas)
                {

                    content += $"<p style=\"margin-left:20px;\"><b>Zona:</b> {area.AreaName}</p>";
                    
                    foreach (var district in area.Districts)
                    {
                        content += $"<p style=\"margin-left:40px;\"><b>Oraș:</b> {district.DistrictName}</p>";

                        content += $"<p style=\"margin-left:60px;\"><b>Localități:</b> {string.Join(", ", district.Localities.Select(l => l.LocalityName).ToList())}</p>";
                    }
                }

                emailService.Recipient = email;
                emailService.MailSubject = $"Permis de acces în zona de frontieră | {license.LicenseNumber} | {DateTime.Now:dd/MM/yyyy}";
                var body = "<p>Bună!</p>";
                body += "<p>Cererea depusă de dumneavoastră pentru obținerea permisului de acces în zona de frontieră a fost aprobată cu succes.</p>";
                body += $"<p><b>Numărul de identificare a permisului:</b> {license.LicenseNumber}</p>";
                body += $"<p><b>Scopul:</b> {activity.ActivityName}</p>";
                body += $"<p><b>Durata:</b> {license.StartDate:dd/MM/yyyy} - {license.EndDate:dd/MM/yyyy} ({(license.EndDate - license.StartDate).TotalDays} zile)</p>";
                body += $"<p><b>Localitatea:</b> </p>";
                body += content;
                body += "<br>";
                body += "<p><b>Atenție:</b> Vă rugăm ca în timpul aflării în zona de frontieră să dețineți cel puțin numărul de identificare a permisului la dumneavoastră.</p>";
                
                emailService.MailBody = body;

                try
                {
                    emailService.SendMail();
                }
                catch (Exception e)
                {
                    response.Errors.Add("Emailul nu a putut fi transmis!");
                    response.Errors.Add(e.ToString());
                    response.StatusCode = HttpStatusCode.InternalServerError;
                }
            }

            #endregion

            #region Send SMS to the user

            var phone = request.RequestReceivingMethods
                .Where(rm => rm.ReceivingMethodId == (int) ReceivingMethods.SMS)
                .Select(rm => rm.ReceivingMethodValue)
                .FirstOrDefault();

            if (!string.IsNullOrWhiteSpace(phone))
            {
                // TODO: send SMS message
            }

            #endregion

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

        public async Task UpdateLicensesStatuses()
        {
            var licenses = await _abaDbContext.Licenses
                .Where(l => l.StatusId == (int) LicenseStatuses.Active)
                .Where(l => l.EndDate.Date <= DateTime.Now.Date)
                .ToListAsync();

            foreach (var license in licenses)
            {
                license.StatusId = (int) LicenseStatuses.Expired;
            }
            
            await _abaDbContext.SaveChangesAsync();
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

            if (!string.IsNullOrWhiteSpace(filter.LicenseNumber))
                query = query.Where(q => EF.Functions.Like(q.LicenseNumber, $"%{filter.LicenseNumber}%"));
            
            if (filter.ActivityId.HasValue)
                query = query.Where(q => q.ActivityId == filter.ActivityId);

            if (filter.StatusId.HasValue)
                query = query.Where(q => q.StatusId == filter.StatusId);
            
            // TODO: filter localities
            if (!string.IsNullOrWhiteSpace(filter.LocalityName))
            {
                query = query.Where(q =>
                    q.LicenseLocalities.Any(ll =>
                        EF.Functions.Like(ll.Locality.LocalityName, $"%{filter.LocalityName}%")) ||
                    q.LicenseLocalities.Any(ll =>
                        EF.Functions.Like(ll.Locality.District.DistrictName, $"%{filter.LocalityName}%")) ||
                    q.LicenseLocalities.Any(ll =>
                        EF.Functions.Like(ll.Locality.District.Area.AreaName, $"%{filter.LocalityName}%")));
            }

            if (filter.CreatedAt != DateTime.MinValue)
                query = query.Where(q => q.CreatedAt.Date == filter.CreatedAt.Date);
            
            if (filter.StartDate != DateTime.MinValue)
                query = query.Where(q => q.StartDate.Date == filter.StartDate.Date);
            
            if (filter.EndDate != DateTime.MinValue)
                query = query.Where(q => q.EndDate.Date == filter.EndDate.Date);
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

        private async Task<string> GetNextLicenseNumber()
        {
            var lastLicenseNumber = await _abaDbContext.Licenses
                .OrderByDescending(l => l.LicenseId)
                .Select(l => l.LicenseNumber)
                .FirstOrDefaultAsync();

            var lastNumber = lastLicenseNumber != null
                ? Convert.ToInt64(lastLicenseNumber.Split('-').Last()) + 1
                : 1;
            
            return $"PA-{lastNumber:000000000}";
        }

    }
}