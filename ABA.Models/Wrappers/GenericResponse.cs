using System.Collections.Generic;
using System.Linq;

namespace ABA.Models.Wrappers
{
    public class Response<T>: Response
    {
        public T Content { get; set; }

        public override bool Success => typeof(T).IsPrimitive || typeof(T) == typeof(decimal) || typeof(T) == typeof(string)
            ? base.Success
            : base.Success && !Equals(Content, default(T));

        public Response()
        {
        }

        public Response(params Info[] messages)
            : base(messages)
        {
        }

        public Response(IEnumerable<Info> messages)
            : this(messages.ToArray())
        {
        }

        public Response(params Warning[] warnings)
            : base(warnings)
        {
        }

        public Response(IEnumerable<Warning> warnings)
            : this(warnings.ToArray())
        {
        }

        public Response(params Error[] errors)
            : base(errors)
        {
        }

        public Response(IEnumerable<Error> errors)
            : this(errors.ToArray())
        {
        }

        public Response(T content)
        {
            Content = content;
        }

        public Response(T content, params Info[] messages)
            : base(messages)
        {
            Content = content;
        }

        public Response(T content, IEnumerable<Info> messages)
            : this(content, messages.ToArray())
        {
        }

        public Response(T content, params Warning[] warnings)
            : base(warnings)
        {
            Content = content;
        }

        public Response(T content, IEnumerable<Warning> warnings)
            : this(content, warnings.ToArray())
        {
        }

        public Response(T content, params Error[] errors)
            : base(errors)
        {
            Content = content;
        }

        public Response(T content, IEnumerable<Error> errors)
            : this(content, errors.ToArray())
        {
        }
    }
}