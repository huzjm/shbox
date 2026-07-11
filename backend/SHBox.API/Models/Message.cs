namespace SHBox.API.Models;

public class Message
{
    public int Id { get; set; }

    public string Sender { get; set; } = "";

    public string Content { get; set; } = "";

    public string Type { get; set; } = "text";

    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}