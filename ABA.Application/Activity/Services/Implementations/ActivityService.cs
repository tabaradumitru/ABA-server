using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ABA.DataTransferObjects;
using ABA.Persistence.ABA;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.Activity.Services.Implementations
{
    public class ActivityService: IActivityService
    {
        private readonly ABADbContext _abaDbContext;

        public ActivityService(ABADbContext abaDbContext)
        {
            _abaDbContext = abaDbContext;
        }

        public async Task<List<ActivityDto>> GetActivities()
        {
            return await _abaDbContext.Activities
                .Select(a => new ActivityDto
                {
                    Id = a.Id,
                    Name = a.Name
                })
                .ToListAsync();
        }
    }
}