using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ABA.DataTransferObjects;
using ABA.Persistence.ABA;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.Locality.Services.Implementations
{
    public class LocalityService: ILocalityService
    {
        private readonly ABADbContext _abaDbContext;

        public LocalityService(ABADbContext abaDbContext)
        {
            _abaDbContext = abaDbContext;
        }

        public async Task<List<AreaDto>> GetAllLocalities()
        {
            return await _abaDbContext.Areas
                .Include(a => a.Districts)
                .ThenInclude(d => d.Localities)
                .Select(a => new AreaDto
                {
                    AreaId = a.AreaId,
                    AreaName = a.AreaName,
                    Districts = a.Districts
                        .Select(d => new DistrictDto
                        {
                            DistrictId = d.DistrictId,
                            DistrictName = d.DistrictName,
                            AreaId = d.AreaId,
                            Localities = d.Localities
                                .Select(l => new LocalityDto
                                {
                                    LocalityId = l.LocalityId,
                                    LocalityName = l.LocalityName,
                                    DistrictId = l.DistrictId
                                })
                                .ToList()
                        })
                        .ToList()
                })
                .ToListAsync();

            // var respon = resp.Select(r => r.AreaName).ToList();
            //
            //
            // response.Areas = await _abaDbContext.Areas
            //     .Select(a => new AreaDto
            //     {
            //         AreaId = a.AreaId,
            //         AreaName = a.AreaName
            //     })
            //     .ToListAsync();
            //
            // response.Districts = await _abaDbContext.Districts
            //     .Select(d => new DistrictDto
            //     {
            //         DistrictId = d.DistrictId,
            //         DistrictName = d.DistrictName,
            //         AreaId = d.AreaId
            //     })
            //     .OrderBy(d => d.AreaId)
            //     .ThenBy(d => d.DistrictName)
            //     .ToListAsync();
            //
            // response.Localities = await _abaDbContext.Localities
            //     .Select(l => new LocalityDto
            //     {
            //         LocalityId = l.LocalityId,
            //         LocalityName = l.LocalityName,
            //         DistrictId = l.DistrictId
            //     })
            //     .OrderBy(l => l.DistrictId)
            //     .ThenBy(l => l.LocalityName)
            //     .ToListAsync();
            //
            // return response;
        }
    }
}