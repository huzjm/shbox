FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["backend/SHBox.API/SHBox.API.csproj", "backend/SHBox.API/"]
RUN dotnet restore "backend/SHBox.API/SHBox.API.csproj"

COPY backend/SHBox.API/ backend/SHBox.API/
RUN dotnet publish "backend/SHBox.API/SHBox.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 5051
ENV ASPNETCORE_URLS=http://0.0.0.0:10000
ENTRYPOINT ["dotnet", "SHBox.API.dll"]
