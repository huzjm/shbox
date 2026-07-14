namespace SHBox.API.Models;

public class DeviceCommand
{
    public int? Id { get; set; }

    public string Type { get; set; } = "";

    public string Sender { get; set; } = "";

    public string Data { get; set; } = "";

    public string? DeviceId { get; set; }

    public string? Status { get; set; }
}