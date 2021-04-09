using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace ABA.Models.Wrappers
{
    public class Response
    {
        public List<Info> Messages { get; set; }

        public string MessagesFlat => Messages.Any() ? string.Join(Environment.NewLine, Messages) : string.Empty;

        public List<Warning> Warnings { get; set; }

        public string WarningsFlat => Warnings.Any() ? string.Join(Environment.NewLine, Warnings) : string.Empty;

        public List<Error> Errors { get; set; }

        public string ErrorsFlat => Errors.Any() ? string.Join(Environment.NewLine, Errors) : string.Empty;

        public virtual bool Success => !Errors.Any();
        public HttpStatusCode StatusCode { get; set; }

        public Response()
        {
            Messages = new List<Info>();
            Warnings = new List<Warning>();
            Errors = new List<Error>();
        }

        public Response(params Info[] messages)
            : this()
        {
            Messages.AddRange(messages);
        }

        public Response(IEnumerable<Info> messages)
            : this(messages.ToArray())
        {
        }

        public Response(params Warning[] warnings)
            : this()
        {
            Warnings.AddRange(warnings);
        }

        public Response(IEnumerable<Warning> warnings)
            : this(warnings.ToArray())
        {
        }

        public Response(params Error[] errors)
            : this()
        {
            Errors.AddRange(errors);
        }

        public Response(IEnumerable<Error> errors)
            : this(errors.ToArray())
        {
        }
    }
}