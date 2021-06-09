using System;
using System.Text;
using System.Transactions;
using ABA.API.Config;
using ABA.BackgroundJobs.RecurrentJobs;
using ABA.Models.Configuration;
using ABA.Persistence.ABA;
using Hangfire;
using Hangfire.MySql;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

namespace ABA.API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddMvc();
            services.AddControllers();
            
            services.AddDbContext<ABADbContext>(o => o.UseMySQL(Configuration.GetConnectionString("ABA")));
            
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Access to the border area.API", Version = "v1" });
            });
            
            services.Configure<AuthorizationConfiguration>(Configuration.GetSection("Authorization"));

            services.AddServices();
            services.AddHttpContextAccessor();

            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        RequireExpirationTime = true,
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey =
                            new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Authorization:SecretKey"])),
                        ValidIssuer = Configuration["Authorization:Issuer"],
                        ValidateIssuer = true,
                        ValidAudience = Configuration["Authorization:Audience"],
                        ValidateAudience = true
                    };
                });
            
            services.AddHangfire(configuration => configuration
                .UseStorage(
                    new MySqlStorage(
                        "Server=localhost;Port=3306;Database=hangfire;User=dumitrutabara;Password=1317;Allow User Variables=True;", 
                        new MySqlStorageOptions
                        {
                            TransactionIsolationLevel = IsolationLevel.ReadCommitted,
                            QueuePollInterval = TimeSpan.FromSeconds(15),
                            JobExpirationCheckInterval = TimeSpan.FromHours(1),
                            CountersAggregateInterval = TimeSpan.FromMinutes(5),
                            PrepareSchemaIfNecessary = true,
                            DashboardJobListLimit = 50000,
                            TransactionTimeout = TimeSpan.FromMinutes(1),
                            TablesPrefix = "Hangfire"
                        })
                    ));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Access to the border area.API v1"));
            }
            
            app.UseHangfireDashboard();
            app.UseHangfireServer(new BackgroundJobServerOptions
            {
                WorkerCount = 20,
                Queues = new[] { "DEFAULT" },
                ServerName = "HangfireJobServer",
            });
            app.UseHttpsRedirection();
            
            // app.UseSpaStaticFiles();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
            
            app.UseSpa(spa =>
            {
                if (env.IsDevelopment()) spa.UseProxyToSpaDevelopmentServer("http://localhost:4200");
            });
            
            RecurrentJobsService.Start();
        }
    }
}
