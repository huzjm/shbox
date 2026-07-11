using Microsoft.AspNetCore.SignalR;
using SHBox.API.Data;
using SHBox.API.Models;

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
}