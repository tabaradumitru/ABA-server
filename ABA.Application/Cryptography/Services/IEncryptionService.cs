using System.Security.Cryptography;
using ABA.Application.Cryptography.Models;

namespace ABA.Application.Cryptography.Services
{
    public interface IEncryptionService
    {
        string Encrypt(string plaintext);
        string Encrypt(byte[] plaintext, string password, KeySize keySize);
        byte[] Encrypt(byte[] plaintext, string password, byte[] iv, KeySize keySize);
        void Encrypt(string plaintextFile, string ciphertextFile, string password, KeySize keySize);
        string Decrypt(string ciphertext);
        string Decrypt(byte[] ciphertext, string password, KeySize keySize);
        void Decrypt(string ciphertextFile, string plaintextFile, string password, KeySize keySize);
        byte[] GenerateKey(string password, KeySize keySize);
        ICryptoTransform CreateEncryptor(string password, byte[] iv, KeySize keySize);
        ICryptoTransform CreateDecryptor(string password, byte[] iv, KeySize keySize);
    }
}