using SHBox.API.Models;

namespace SHBox.API.Services;

public static class CommandRouting
{
    public static string? ResolveTargetGroup(DeviceCommand command)
    {
        if (command is null)
        {
            return null;
        }

        var deviceId = command.DeviceId?.Trim();
        return string.IsNullOrWhiteSpace(deviceId) ? null : deviceId;
    }
}
