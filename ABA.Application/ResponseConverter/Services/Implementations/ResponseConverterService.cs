using System.Net;
using System.Net.Http;
using ABA.Models.Wrappers;

namespace ABA.Application.ResponseConverter.Services.Implementations
{
    public class ResponseConverterService: IResponseConverterService
    {
        // public IStatusCode Convert<T>(Response<T> response)
        // {
        //     // switch (response.StatusCode)
        //     // {
        //     //     case HttpStatusCode.OK: return new OkObjectResult()(response.Content);
        //     //     case HttpStatusCode.Created: return new ObjectResult(response.Content) { StatusCode = (int)HttpStatusCode.Created};
        //     //     case HttpStatusCode.NoContent: return new ObjectResult(null) {StatusCode = (int) HttpStatusCode.NoContent};
        //     //     case HttpStatusCode.BadRequest: return new BadRequestObjectResult(response);
        //     //     case HttpStatusCode.Conflict: return  new ObjectResult(response) {StatusCode = (int)HttpStatusCode.Conflict };
        //     //     case HttpStatusCode.NotFound: return new NotFoundObjectResult(response);
        //     //     case HttpStatusCode.InternalServerError: return new ObjectResult(response) { StatusCode = (int)HttpStatusCode.InternalServerError};
        //     //     default: return new OkObjectResult(response);
        //     // }
        //
        //     var resp = new HttpResponseMessage();
        //
        //     if (resp.StatusCode == HttpStatusCode.OK)
        //     {
        //         return Ok(response.Content);
        //         // return new OkObjectRes
        //         // resp = new HttpResponseMessage(resp.StatusCode);
        //         // resp.Content = response.Content;
        //     }
        //
        //     return resp;
        // }
    }
}