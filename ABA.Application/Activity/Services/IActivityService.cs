using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects;

namespace ABA.Application.Activity.Services
{
    public interface IActivityService
    {
        Task<List<ActivityDto>> GetActivities();
    }
}