using Microsoft.AspNetCore.SignalR;
using SHBox.API.Data;
using SHBox.API.Models;
using SHBox.API.Services;

namespace SHBox.API.Hubs;

public class ChatHub : Hub
{
    private readonly SHBoxDbContext _context;

    public ChatHub(SHBoxDbContext context)
    {
        _context = context;
    }

    public async Task SendMessage(Message message)
    {
        message.Timestamp = DateTime.UtcNow;

        _context.Messages.Add(message);

        await _context.SaveChangesAsync();

        await Clients.All.SendAsync(
            "ReceiveMessage",
            message);
    }

    public async Task SendCommand(DeviceCommand command)
    {
        command.Status ??= "queued";

        var record = new DeviceCommandRecord
        {
            Type = command.Type,
            Sender = command.Sender,
            Data = command.Data,
            DeviceId = command.DeviceId,
            Status = command.Status
        };

        _context.DeviceCommandRecords.Add(record);
        await _context.SaveChangesAsync();

        command.Id = record.Id;
        command.Status = record.Status;

        var targetGroup = CommandRouting.ResolveTargetGroup(command);
        if (string.IsNullOrWhiteSpace(targetGroup))
        {
            await Clients.All.SendAsync("ReceiveCommand", command);
            return;
        }

        await Clients.Group(targetGroup).SendAsync("ReceiveCommand", command);
    }

    public async Task MarkCommandCompleted(string deviceId, int commandId)
    {
        var record = await _context.DeviceCommandRecords.FindAsync(commandId);
        if (record is null)
        {
            return;
        }

        record.Status = "completed";
        record.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
    }

    public override async Task OnConnectedAsync()
    {
        var deviceId = Context.GetHttpContext()?.Request.Query["deviceId"].ToString();
        if (!string.IsNullOrWhiteSpace(deviceId))
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, deviceId);
        }

        await base.OnConnectedAsync();
    }
}