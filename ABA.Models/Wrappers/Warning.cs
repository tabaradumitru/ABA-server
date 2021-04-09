namespace ABA.Models.Wrappers
{
    public sealed class Warning
    {
        public string Message { get; set; }

        public Warning()
        {
        }

        public Warning(string message)
        {
            Message = message;
        }

        public override string ToString()
        {
            return Message;
        }
    }
}