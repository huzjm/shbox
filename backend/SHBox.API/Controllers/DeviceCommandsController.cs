using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SHBox.API.Data;
using SHBox.API.Models;

namespace SHBox.API.Controllers;

[ApiController]
[Route("api/device-commands")]
public class DeviceCommandsController : ControllerBase
{
    private readonly SHBoxDbContext _context;

    public DeviceCommandsController(SHBoxDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetCommands()
    {
        var commands = await _context.DeviceCommandRecords
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();

        return Ok(commands);
    }

    [HttpPost("{id}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] UpdateStatusRequest request)
    {
        var record = await _context.DeviceCommandRecords.FindAsync(id);
        if (record is null)
        {
            return NotFound();
        }

        record.Status = request.Status;
        record.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        return Ok(record);
    }
}

public class UpdateStatusRequest
{
    public string Status { get; set; } = "queued";
}
