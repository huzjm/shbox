namespace SHBox.API.DTOs
{
    public class MessageDto
    {
        public string Sender { get; set; } = "";
        public string Content { get; set; } = "";
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
        public string Type { get; set; } = "text"; // text, image, voice
    }
}