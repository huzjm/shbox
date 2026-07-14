using Microsoft.EntityFrameworkCore;
using SHBox.API.Data;
using SHBox.API.Models;

namespace SHBox.API.Tests;

public class DeviceCommandPersistenceTests
{
    [Fact]
    public void DeviceCommand_CanCarryPersistedId()
    {
        var command = new DeviceCommand
        {
            Type = "TakePhoto",
            Sender = "Huzefa"
        };

        command.Id = 42;

        Assert.Equal(42, command.Id);
    }

    [Fact]
    public async Task CanPersistAndUpdateCommandStatus()
    {
        var options = new DbContextOptionsBuilder<SHBoxDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;

        await using var context = new SHBoxDbContext(options);

        var record = new DeviceCommandRecord
        {
            Type = "TakePhoto",
            Sender = "Huzefa",
            Data = string.Empty,
            DeviceId = "sakina-shbox",
            Status = "queued"
        };

        context.DeviceCommandRecords.Add(record);
        await context.SaveChangesAsync();

        record.Status = "completed";
        record.UpdatedAt = DateTime.UtcNow;
        await context.SaveChangesAsync();

        var persisted = await context.DeviceCommandRecords.SingleAsync();

        Assert.Equal("completed", persisted.Status);
        Assert.NotNull(persisted.UpdatedAt);
    }
}
