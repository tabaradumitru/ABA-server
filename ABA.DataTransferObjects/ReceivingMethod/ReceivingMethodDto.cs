namespace ABA.DataTransferObjects.ReceivingMethod
{
    public class ReceivingMethodDto
    {
        public int ReceivingMethodId { get; set; }
        public string ReceivingMethodName { get; set; }
        public byte IsRequired { get; set; }
    }
}