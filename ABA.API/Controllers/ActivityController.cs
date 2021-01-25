using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.Application.Activity.Services;
using ABA.DataTransferObjects;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ActivityController: ControllerBase
    {
        private readonly IActivityService _activityService;

        public ActivityController(IActivityService activityService)
        {
            _activityService = activityService;
        }

        [HttpGet]
        public async Task<List<ActivityDto>> GetActivities()
        {
            return await _activityService.GetActivities();
        }
    }
}