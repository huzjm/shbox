using Microsoft.AspNetCore.SignalR.Client;

Console.WriteLine("Starting SHBox client...");

var connection = new HubConnectionBuilder()
    .WithUrl("http://localhost:5051/chatHub")
    .WithAutomaticReconnect()
    .Build();

connection.On<object>("ReceiveMessage", (message) =>
{
    Console.WriteLine($"📩 {message}");
});

await connection.StartAsync();

Console.WriteLine("Connected to SHBox ❤️");

while (true)
{
    Console.Write("Message: ");
    var text = Console.ReadLine();

    await connection.SendAsync("SendMessage", new
    {
        Sender = "Huzefa",
        Content = text,
        Type = "text"
    });
}