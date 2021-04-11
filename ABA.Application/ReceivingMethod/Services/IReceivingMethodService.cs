using System.Collections.Generic;
using System.Threading.Tasks;
using ABA.DataTransferObjects.ReceivingMethod;

namespace ABA.Application.ReceivingMethod.Services
{
    public interface IReceivingMethodService
    {
        Task<List<ReceivingMethodDto>> GetReceivingMethods();
    }
}