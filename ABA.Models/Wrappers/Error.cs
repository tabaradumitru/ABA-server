namespace ABA.Models.Wrappers
{
    public sealed class Error
    {
        public string Code { get; set; }
        public string Class { get; set; }
        public string Message { get; set; }

        public Error()
        {
        }

        public Error(string message)
        {
            Message = message;
        }

        public Error(string message, string @class)
            : this(message)
        {
            Class = @class;
        }

        public Error(string message, string @class, object code)
            : this(message, @class)
        {
            Code = code.ToString();
        }

        public override string ToString()
        {
            return Message;
        }
    }
}