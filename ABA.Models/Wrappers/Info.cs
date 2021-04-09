namespace ABA.Models.Wrappers
{
    public sealed class Info
    {
        public string Message { get; set; }

        public Info(string message)
        {
            Message = message;
        }

        public override string ToString()
        {
            return Message;
        }
    }
}