using Microsoft.EntityFrameworkCore;
using SQLChallenge.Models;

public class AppDbContext : DbContext
{
    public DbSet<Employee> Employees { get; set; }
    public DbSet<WorkOrder> WorkOrders { get; set; }
    public DbSet<Line> Lines { get; set; }
    public DbSet<Product> Products { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        string connectionString = "Server=localhost;Database=IndustryDb;Trusted_Connection=True;";
        optionsBuilder.UseSqlServer(connectionString);
        
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<WorkOrder>()
            .HasOne(w => w.Line)
            .WithMany(l => l.WorkOrders)
            .HasForeignKey(w => w.LineId);

        modelBuilder.Entity<WorkOrder>()
            .HasOne(w => w.Product)
            .WithMany(p => p.WorkOrders)
            .HasForeignKey(w => w.ProductId);
    }
}
