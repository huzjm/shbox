using Microsoft.AspNetCore.SignalR.Client;

var connection = new HubConnectionBuilder()
    .WithUrl("http://localhost:5051/chatHub")
    .Build();

connection.On<object>("ReceiveMessage", (message) =>
{
    Console.WriteLine($"📩 {message}");
});

await connection.StartAsync();

Console.WriteLine("Sending TakePhoto command...");
await connection.SendAsync("SendCommand", new
{
    type = "TakePhoto",
    sender = "Huzefa",
    data = "",
    deviceId = "sakina-shbox",
    status = "queued"
});

Console.WriteLine("Command sent.");
Console.ReadLine();