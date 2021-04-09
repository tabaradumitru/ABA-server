namespace ABA.Application.Cryptography.Providers
{
    public static class Settings
    {
        /// <summary>
        /// The number of iterations used to derive hashes.
        /// Default is 10000.
        /// </summary>
        public static int HashIterations;

        private const int _hashIterations = 10000;
        
        static Settings()
        {
            Reset();
        }
        
        /// <summary>
        /// Resets all the settings to their default values
        /// </summary>
        public static void Reset()
        {
            HashIterations = _hashIterations;
        }
    }
}