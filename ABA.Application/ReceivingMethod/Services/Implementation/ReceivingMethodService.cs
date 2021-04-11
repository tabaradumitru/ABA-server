using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ABA.DataTransferObjects.ReceivingMethod;
using ABA.Persistence.ABA;
using Microsoft.EntityFrameworkCore;

namespace ABA.Application.ReceivingMethod.Services.Implementation
{
    public class ReceivingMethodService: IReceivingMethodService
    {
        private readonly ABADbContext _abaDbContext;

        public ReceivingMethodService(ABADbContext abaDbContext)
        {
            _abaDbContext = abaDbContext;
        }

        public async Task<List<ReceivingMethodDto>> GetReceivingMethods()
        {
            return await _abaDbContext.ReceivingMethods
                .Select(m => new ReceivingMethodDto
                {
                    ReceivingMethodId = m.ReceivingMethodId,
                    ReceivingMethodName = m.ReceivingMethodName,
                    IsRequired = m.IsRequired
                })
                .ToListAsync();
        }
    }
}