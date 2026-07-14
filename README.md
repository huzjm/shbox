# SHBox (Project Portal)

A cross-platform personal communication and IoT system between a Raspberry Pi touchscreen device and a mobile application.

## Stack
- Flutter (Raspberry Pi + Mobile)
- ASP.NET Core Backend
- SignalR for real-time messaging
- SQLite (initial database)

## Features (MVP)
- Real-time messaging
- Image sharing
- Voice notes (later)
- Raspberry Pi kiosk interface

## Architecture
Flutter Apps ↔ ASP.NET Core API ↔ SQLite

## Status
Phase 1: Remote deployment prep

## Remote deployment goal
This app is intended to run on a Raspberry Pi as a kiosk device while the backend stays reachable from anywhere, so your partner can use it from Karachi while you are in Calgary.

## Recommended setup
1. Host the API on a VPS, cloud VM, or a home server with a public IP or domain name.
2. Run PostgreSQL instead of SQLite for the shared database.
3. Point the Pi app at the hosted backend with SHBOX_SERVER_URL.
4. Launch the Flutter app automatically on boot in kiosk mode.

## Database options
- Local development: SQLite (default)
- Shared/remote deployment: PostgreSQL

### PostgreSQL via Docker Compose
Run the following from the repository root:

```bash
docker compose up -d
```

This starts:
- PostgreSQL on port 5432
- the API on port 5051

Set the following environment variables for the API when deploying remotely:

```bash
DatabaseProvider=Postgres
ConnectionStrings__DefaultConnection="Host=YOUR_HOST;Port=5432;Database=shbox;Username=shbox;Password=YOUR_PASSWORD"
```

## Raspberry Pi kiosk mode
The project includes a launcher script and a systemd unit for a Pi kiosk experience.

### Install on Raspberry Pi
```bash
sudo cp scripts/shbox-kiosk.service /etc/systemd/system/shbox-kiosk.service
sudo systemctl daemon-reload
sudo systemctl enable shbox-kiosk
sudo systemctl start shbox-kiosk
```

### Where to set the environment variables
- For the current shell session on Linux or Raspberry Pi:
  ```bash
  export SHBOX_SERVER_URL=https://your-domain.com
  export SHBOX_DEVICE_ID=sakina-shbox
  ```
- To make them persist for the Pi user:
  ```bash
  echo 'export SHBOX_SERVER_URL=https://your-domain.com' >> ~/.bashrc
  echo 'export SHBOX_DEVICE_ID=sakina-shbox' >> ~/.bashrc
  source ~/.bashrc
  ```
- For a systemd service, set them directly in the service file as already shown in [scripts/shbox-kiosk.service](scripts/shbox-kiosk.service).

### Required environment variables
```bash
SHBOX_SERVER_URL=https://your-domain.com
SHBOX_DEVICE_ID=sakina-shbox
```

The launcher script will start the Flutter app in a fullscreen-style kiosk session on boot.

## Public URL and reverse proxy
For a real public deployment, put the API behind a reverse proxy such as Nginx and expose HTTPS with your domain name.

A sample Nginx config is available in [scripts/nginx-shbox.conf](scripts/nginx-shbox.conf).

### Example
```bash
sudo cp scripts/nginx-shbox.conf /etc/nginx/conf.d/shbox.conf
sudo nginx -t
sudo systemctl reload nginx
```

Then point the app at:
```bash
SHBOX_SERVER_URL=https://your-domain.com
```