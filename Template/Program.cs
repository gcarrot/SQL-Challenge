using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace SQLChallenge
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var stopwatch = Stopwatch.StartNew();

            var context = new AppDbContext();

            var employees = context.Employees.ToList();
            foreach (var e in employees)
            {
                Console.WriteLine(e.Name);
            }

            stopwatch.Stop();
            Console.WriteLine($"Čas izvajanja: {stopwatch.ElapsedMilliseconds} ms");
        }
    }

}
