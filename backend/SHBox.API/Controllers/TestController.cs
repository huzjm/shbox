using Microsoft.AspNetCore.Mvc;

namespace SHBox.API.Controllers;

[ApiController]
[Route("api/test")]
public class TestController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok("SHBox backend is running ❤️");
    }
}