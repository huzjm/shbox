using Microsoft.AspNetCore.Mvc;
using SHBox.API.Data;
using SHBox.API.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using SHBox.API.Hubs;
namespace SHBox.API.Controllers;


[ApiController]
[Route("api/photos")]
public class PhotoController : ControllerBase
{

    private readonly SHBoxDbContext _context;
private readonly IHubContext<ChatHub> _hub;


   public PhotoController(
    SHBoxDbContext context,
    IHubContext<ChatHub> hub)
{
    _context=context;
    _hub=hub;
}

    [HttpGet]
public async Task<IActionResult> GetPhotos()
{
    var photos = await _context.Photos
        .OrderByDescending(p => p.Timestamp)
        .ToListAsync();

    return Ok(photos);
}    

    [HttpPost("upload")]
    public async Task<IActionResult> Upload(
        [FromForm] IFormFile file,
    [FromForm] string sender,
    [FromForm] string caption = "")
    {

        if(file == null)
            return BadRequest();


        var folder =
        Path.Combine(
            Directory.GetCurrentDirectory(),
            "storage/photos"
        );


        Directory.CreateDirectory(folder);



        var fileName =
        Guid.NewGuid()
        + Path.GetExtension(file.FileName);



        var path =
        Path.Combine(
            folder,
            fileName
        );


        using(var stream =
        new FileStream(path,FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }



        var photo =
        new Photo
        {
            FileName=fileName,
            Sender=sender,
            Caption=caption
        };


        _context.Photos.Add(photo);

        await _context.SaveChangesAsync();
        await _hub.Clients.All.SendAsync(
    "NewPhoto",
    photo
);

        return Ok(photo);

    }

}