# AI Testing Infrastructure

This repository contains a Docker Compose setup for running Open WebUI and LiteLLM for AI testing and development.

## Architecture

- **Open WebUI**: Web interface for interacting with various AI models
- **LiteLLM**: Proxy server for unified access to multiple LLM providers
- **PostgreSQL**: Database for storing application data
- **Redis**: Cache layer for LiteLLM

## Prerequisites

- Docker and Docker Compose installed
- API keys for the LLM providers you want to use (OpenAI, Anthropic, etc.)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/Huper-Labs/chat-app.git
   cd chat-app
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

3. Edit the `.env` file with your actual values:
   ```bash
   POSTGRES_PASSWORD=your-secure-password
   WEBUI_SECRET_KEY=your-secret-key
   LITELLM_MASTER_KEY=your-master-key
   ```

4. Add your LLM provider API keys to `.env`:
   ```bash
   OPENAI_API_KEY=your-openai-key
   ANTHROPIC_API_KEY=your-anthropic-key
   ```

5. Start the services:
   ```bash
   docker-compose up -d
   ```

## Accessing the Services

- **Open WebUI**: http://localhost:3000
- **LiteLLM API**: http://localhost:4000
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## Configuration

### LiteLLM Models

Edit `config/litellm/config.yaml` to add or modify available models. The default configuration includes:
- GPT-4
- GPT-3.5 Turbo
- Claude 3 Opus
- Claude 3 Sonnet

### Open WebUI Settings

Custom configurations can be added to `config/open-webui/`.

## Management

### View logs
```bash
docker-compose logs -f [service-name]
```

### Stop all services
```bash
docker-compose down
```

### Update services
```bash
docker-compose pull
docker-compose up -d
```

### Backup data
```bash
./scripts/backup.sh
```

## Directory Structure

```
.
├── docker-compose.yml      # Service orchestration
├── .env                    # Environment variables (not in git)
├── config/                 # Service configurations
│   ├── litellm/
│   └── open-webui/
├── volumes/                # Persistent data (not in git)
│   ├── postgres/
│   ├── redis/
│   └── open-webui/
└── scripts/                # Management scripts
    ├── setup.sh
    └── backup.sh
```

## Security Notes

- Never commit `.env` file to version control
- Use strong passwords for all services
- Consider using Docker secrets for production deployments
- Regularly backup your data using the provided backup script

## Troubleshooting

### Services not starting
- Check logs: `docker-compose logs [service-name]`
- Ensure all required environment variables are set
- Verify ports 3000, 4000, 5432, and 6379 are not in use

### Database connection issues
- Ensure PostgreSQL is fully started before dependent services
- Check database credentials in `.env` match docker-compose.yml

### LiteLLM configuration errors
- Verify API keys are correctly set in `.env`
- Check `config/litellm/config.yaml` syntax
- Review LiteLLM logs for specific error messages