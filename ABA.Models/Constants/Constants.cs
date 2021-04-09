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
}