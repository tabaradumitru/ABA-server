namespace ABA.Models.Constants
{
    public enum RequestStatuses
    {
        Active = 1,
        Approved = 2,
        Rejected = 3,
        Canceled = 4,
        Expired = 5
    }

    public static class Role
    {
        public const string User = "User";
        public const string Employee = "Employee";
    }

    public enum LicenseStatuses
    {
        Active = 1,
        Expired = 2,
        Canceled = 3
    }

    public enum ReceivingMethods
    {
        SMS = 1,
        Email = 2
    }
}