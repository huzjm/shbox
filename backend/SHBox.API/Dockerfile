FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["SHBox.API.csproj", "./"]
RUN dotnet restore "SHBox.API.csproj"
COPY . .
RUN dotnet publish "SHBox.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 5051
ENV ASPNETCORE_URLS=http://0.0.0.0:5051
ENTRYPOINT ["dotnet", "SHBox.API.dll"]
