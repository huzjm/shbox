using Microsoft.EntityFrameworkCore;
using SHBox.API.Models;

namespace SHBox.API.Data;

public class SHBoxDbContext : DbContext
{
    public SHBoxDbContext(DbContextOptions<SHBoxDbContext> options)
        : base(options)
    {
    }

    public DbSet<Message> Messages { get; set; }
    public DbSet<Photo> Photos { get; set; }
    public DbSet<DeviceCommandRecord> DeviceCommandRecords { get; set; }
}