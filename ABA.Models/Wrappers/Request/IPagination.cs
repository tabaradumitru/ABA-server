namespace ABA.Models.Wrappers.Request
{
    public interface IPagination
    {
        int Page { get; set; }
        int PageSize { get; set; }
    }
}