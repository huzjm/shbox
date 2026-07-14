# Architecture

## Overview
SHBox is a personal communication and IoT ecosystem built around a Raspberry Pi device in Karachi and a remote controller experience from Calgary. The system currently uses a simple event-driven architecture with an ASP.NET Core backend, SignalR for real-time messaging, and Flutter clients.

## Current Architecture

### Clients
- Mobile App (Android)
- Raspberry Pi touchscreen app

### Backend
- ASP.NET Core Web API
- SignalR hub for real-time message and command delivery
- Static file hosting for stored photos

### Data Layer
- SQLite for local development
- EF Core models for messages and photos
- File storage under the backend storage folder

## Current Implementation Status
- Real-time messaging is working through SignalR.
- Messages are stored in the database.
- Photo upload and gallery retrieval are implemented.
- The backend broadcasts photo and command events to connected clients.
- The Flutter client can request and receive remote camera commands.

## Architectural Gaps
- The mobile app still depends on a hard-coded local SignalR URL.
- The system does not yet have device identity, authentication, or command ownership.
- The backend is still development-oriented and not yet cloud-ready.
- Storage is local filesystem-based, not yet cloud object storage.
- The command pipeline is broadcast-based rather than device-scoped.

## Recommended Next Milestones
1. Make client and backend configuration environment-driven.
2. Introduce device identity and ownership for each SHBox instance.
3. Persist commands and add a command lifecycle state.
4. Move from SQLite to PostgreSQL or another managed free-tier database for staging.
5. Add cloud-backed storage for photos and future voice/video assets.
6. Add authentication and secure device registration.

## Communication Flow
User → Flutter App → ASP.NET Core API → SignalR → Other Client