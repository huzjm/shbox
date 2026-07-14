namespace SHBox.API.Models;

public class DeviceCommandRecord
{
    public int Id { get; set; }

    public string Type { get; set; } = "";

    public string Sender { get; set; } = "";

    public string Data { get; set; } = "";

    public string? DeviceId { get; set; }

    public string Status { get; set; } = "queued";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public DateTime? UpdatedAt { get; set; }
}
