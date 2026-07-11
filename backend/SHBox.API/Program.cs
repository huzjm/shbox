using Microsoft.EntityFrameworkCore;
using SHBox.API.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSignalR();

builder.Services.AddDbContext<SHBoxDbContext>(options =>
    options.UseSqlite(
        builder.Configuration.GetConnectionString("DefaultConnection")));


builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyHeader()
              .AllowAnyMethod()
              .AllowAnyOrigin();
    });
});
builder.WebHost.UseUrls("http://0.0.0.0:5051");
var app = builder.Build();

app.UseCors("AllowAll");

app.MapControllers();
app.MapHub<SHBox.API.Hubs.ChatHub>("/chatHub");

app.Run();