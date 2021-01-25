using ABA.Application.Activity.Services;
using ABA.Application.Activity.Services.Implementations;
using Microsoft.Extensions.DependencyInjection;

namespace ABA.API.Config
{
    public static class ServicesSetup
    {
        public static void AddABAServices(this IServiceCollection services)
        {
            services.AddTransient<IActivityService, ActivityService>();
        }
    }
}