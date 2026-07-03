# Architecture

## Overview
Two Flutter clients communicate with an ASP.NET Core backend.

## Clients
- Mobile App (Android)
- Raspberry Pi Touchscreen App

## Backend
- ASP.NET Core API
- SignalR hub for real-time messaging

## Database
- SQLite (initial)
- PostgreSQL (future upgrade)

## Communication Flow
User → Flutter App → API → SignalR → Other Device