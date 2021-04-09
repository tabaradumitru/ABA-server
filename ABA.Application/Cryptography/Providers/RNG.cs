using System.Security.Cryptography;

namespace ABA.Application.Cryptography.Providers
{
    public static class RNG
    {
        private static readonly RandomNumberGenerator Random;

        static RNG()
        {
            Random = RandomNumberGenerator.Create();
        }

        public static byte[] GenerateRandomBytes(int size)
        {
            var bytes = new byte[size];
            Random.GetBytes(bytes);

            return bytes;
        }
    }
}