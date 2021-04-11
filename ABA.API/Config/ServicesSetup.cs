using System;
using ABA.Application.Activity.Services;
using ABA.Application.Activity.Services.Implementations;
using ABA.Application.Authentication.Services;
using ABA.Application.Authentication.Services.Implementations;
using ABA.Application.Cryptography.Services;
using ABA.Application.Cryptography.Services.Implementation;
using ABA.Application.License.Services;
using ABA.Application.License.Services.Implementations;
using ABA.Application.Locality.Services;
using ABA.Application.Locality.Services.Implementations;
using ABA.Application.ReceivingMethod.Services;
using ABA.Application.ReceivingMethod.Services.Implementation;
using ABA.Application.Request.Services;
using ABA.Application.Request.Services.Implementations;
using ABA.Application.ResponseConverter.Services;
using ABA.Application.ResponseConverter.Services.Implementations;
using Microsoft.Extensions.DependencyInjection;

namespace ABA.API.Config
{
    public static class ServicesSetup
    {
        public static void AddServices(this IServiceCollection services)
        {
            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

            services.AddTransient<IActivityService, ActivityService>();
            services.AddTransient<ILocalityService, LocalityService>();
            services.AddTransient<IRequestService, RequestService>();
            services.AddTransient<ILicenseService, LicenseService>();
            services.AddTransient<IAuthenticationService, AuthenticationService>();
            services.AddTransient<IResponseConverterService, ResponseConverterService>();
            services.AddTransient<IEncryptionService, EncryptionService>();
            services.AddTransient<ITokenService, TokenService>();
            services.AddTransient<IReceivingMethodService, ReceivingMethodService>();
        }
    }
}