namespace SHBox.API.Models;

public class Photo
{
    public int Id { get; set; }

    public string FileName { get; set; } = "";

    public string Sender { get; set; } = "";

    public string Caption { get; set; } = "";

    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}