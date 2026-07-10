using Microsoft.AspNetCore.SignalR;
using SHBox.API.DTOs;

namespace SHBox.API.Hubs
{
    public class ChatHub : Hub
    {
        public async Task SendMessage(object message)
{
    await Clients.All.SendAsync("ReceiveMessage", message);
}
    }
}