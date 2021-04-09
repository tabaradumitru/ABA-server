using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.Application.Activity.Services;
using ABA.DataTransferObjects;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ABA.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ActivitiesController: ControllerBase
    {
        private readonly IActivityService _activityService;

        public ActivitiesController(IActivityService activityService)
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