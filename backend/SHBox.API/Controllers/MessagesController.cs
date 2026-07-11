using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SHBox.API.Data;

namespace SHBox.API.Controllers;

[ApiController]
[Route("api/messages")]
public class MessagesController : ControllerBase
{
    private readonly SHBoxDbContext _context;

    public MessagesController(SHBoxDbContext context)
    {
        _context = context;
    }


    [HttpGet]
    public async Task<IActionResult> GetMessages()
    {
        var messages = await _context.Messages
            .OrderBy(m => m.Timestamp)
            .ToListAsync();

        return Ok(messages);
    }
}