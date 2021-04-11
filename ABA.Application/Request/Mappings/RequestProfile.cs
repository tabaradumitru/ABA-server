using AutoMapper;

namespace ABA.Application.Request.Mappings
{
    public class RequestProfile: Profile
    {
        public RequestProfile()
        {
            CreateMap<Persistence.ABA.Entities.Request, Persistence.ABA.Entities.Request>()
                .ForMember(dest => dest.RequestId, source => source.Ignore());
        }
    }
}