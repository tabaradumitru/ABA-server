using System.Collections.Generic;
using System.Linq;

namespace ABA.Models.Wrappers
{
    public static class ListExtension
    {
        public static void Add(this List<Info> list, string message, params object[] args)
        {
            list.Add(new Info(string.Format(message, args)));
        }

        public static void Add(this List<Info> list, params string[] messages)
        {
            list.AddRange(messages.Select(m => new Info(m)));
        }

        public static void AddRange(this List<Info> list, IEnumerable<string> messages)
        {
            list.AddRange(messages.Select(m => new Info(m)));
        }

        public static void Add(this List<Error> list, string message, params object[] args)
        {
            list.Add(new Error(string.Format(message, args)));
        }

        public static void Add(this List<Error> list, params string[] messages)
        {
            list.AddRange(messages.Select(m => new Error(m)));
        }

        public static void AddRange(this List<Error> list, IEnumerable<string> messages)
        {
            list.AddRange(messages.Select(m => new Error(m)));
        }

        public static void Add(this List<Warning> list, string message, params object[] args)
        {
            list.Add(new Warning(string.Format(message, args)));
        }

        public static void Add(this List<Warning> list, params string[] messages)
        {
            list.AddRange(messages.Select(m => new Warning(m)));
        }

        public static void AddRange(this List<Warning> list, IEnumerable<string> messages)
        {
            list.AddRange(messages.Select(m => new Warning(m)));
        }
    }
}