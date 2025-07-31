# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
AI Testing Infrastructure using Docker Compose to run Open WebUI and LiteLLM for AI model testing and development.

## Commands
- `./scripts/setup.sh` - Initial setup (creates directories, copies .env template, pulls images)
- `docker-compose up -d` - Start all services
- `docker-compose down` - Stop all services
- `docker-compose logs -f [service]` - View logs for a specific service
- `./scripts/backup.sh` - Backup all data and configurations

## Architecture
- **Open WebUI** (port 3000): Web interface for AI interactions
- **LiteLLM** (port 4000): Proxy for multiple LLM providers
- **PostgreSQL** (port 5432): Database for both services
- **Redis** (port 6379): Cache layer for LiteLLM

Configuration files are in `config/` directory, with service-specific subdirectories.
Data volumes are mounted in `volumes/` directory (gitignored).