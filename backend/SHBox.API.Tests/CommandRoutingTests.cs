using SHBox.API.Models;
using SHBox.API.Services;

namespace SHBox.API.Tests;

public class CommandRoutingTests
{
    [Fact]
    public void ResolveTargetGroup_ReturnsDeviceId_WhenSupplied()
    {
        var command = new DeviceCommand
        {
            Type = "TakePhoto",
            DeviceId = "sakina-shbox"
        };

        var result = CommandRouting.ResolveTargetGroup(command);

        Assert.Equal("sakina-shbox", result);
    }

    [Fact]
    public void ResolveTargetGroup_ReturnsNull_WhenDeviceIdMissing()
    {
        var command = new DeviceCommand
        {
            Type = "TakePhoto"
        };

        var result = CommandRouting.ResolveTargetGroup(command);

        Assert.Null(result);
    }
}
