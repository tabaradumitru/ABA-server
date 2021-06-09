using System.Linq;
using ABA.BackgroundJobs.RecurrentJobs.Jobs;
using Hangfire;
using Hangfire.Storage;

namespace ABA.BackgroundJobs.RecurrentJobs
{
    public class RecurrentJobsService
    {
        public static void Start()
        {
            RemoveAllHangfireJobs();
            RecurringJob.AddOrUpdate<UpdateLicensesStatuses>(job => job.Start(), Cron.Hourly(23));
        }
        
        private static void RemoveAllHangfireJobs()
        {
            var hangfireMonitor = JobStorage.Current.GetMonitoringApi();

            JobStorage.Current.GetConnection().GetRecurringJobs().ForEach(xx => RecurringJob.RemoveIfExists(xx.Id));
            hangfireMonitor.ProcessingJobs(0, int.MaxValue).ForEach(xx => BackgroundJob.Delete(xx.Key));
            hangfireMonitor.ScheduledJobs(0, int.MaxValue).ForEach(xx => BackgroundJob.Delete(xx.Key));
            hangfireMonitor.Queues().ToList()
                .ForEach(xx => hangfireMonitor.EnqueuedJobs(xx.Name, 0, int.MaxValue).ForEach(x => BackgroundJob.Delete(x.Key)));
        }
    }
}