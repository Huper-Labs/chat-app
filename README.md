# AI Testing Infrastructure

This repository contains a Docker Compose setup for running Open WebUI and LiteLLM for AI testing and development.

## Architecture

- **Open WebUI**: Full-featured web interface for interacting with various AI models
  - RAG (Retrieval Augmented Generation) support with embeddings
  - Web search integration
  - Image generation capabilities
  - Code execution with Pyodide
  - Speech-to-text with Whisper
  - Auto-tagging and autocomplete
- **LiteLLM**: Unified proxy for multiple LLM providers
  - Supports OpenAI, Anthropic, Google, Cohere, Mistral, Groq, and more
  - Load balancing and failover
  - Usage tracking and rate limiting
- **PostgreSQL**: Database for application data and vector storage
- **Redis**: Cache layer and websocket support for scalability

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

3. Edit the `.env` file with your actual values. Key configurations include:
   ```bash
   # Core settings
   POSTGRES_PASSWORD=your-secure-password
   WEBUI_SECRET_KEY=your-secret-key
   LITELLM_MASTER_KEY=your-master-key
   WEBUI_URL=http://localhost:3000  # Update for production
   
   # LLM Provider API Keys (prefix with PROVIDER_)
   PROVIDER_OPENAI_API_KEY=sk-...
   PROVIDER_ANTHROPIC_API_KEY=sk-ant-...
   # Add other providers as needed
   ```

4. Review and adjust feature flags in `.env`:
   - `ENABLE_SIGNUP`: Allow new user registrations
   - `ENABLE_WEB_SEARCH`: Enable web search capabilities
   - `ENABLE_IMAGE_GENERATION`: Enable image generation features
   - `ENABLE_CODE_EXECUTION`: Enable code interpreter
   - See `.env.example` for all available options

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

**OpenAI Models:**
- GPT-4o Series: `gpt-4o`, `gpt-4o-mini`
- GPT-4.1 Series (Coding-Focused): `gpt-4.1`, `gpt-4.1-mini`, `gpt-4.1-nano`
- o-Series (Reasoning): `o1`, `o1-mini`, `o1-pro`
- o3 Series (Latest): `o3`, `o3-pro`, `o3-mini`
- Legacy: `gpt-4`, `gpt-4-turbo`, `gpt-3.5-turbo`

**Anthropic Models:**
- Claude 3 Opus, Sonnet, Haiku
- Claude 3.5 Sonnet

**Other Providers:**
- Google Gemini Pro, Gemini 1.5 Pro/Flash
- Mistral, Cohere, Groq models
- And 10+ more providers

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

## Setting Up User Tracking (LiteLLM + Open WebUI)

Follow these steps to enable per-user usage tracking:

1. **Access LiteLLM UI**: Navigate to http://localhost:4000
   - Login with credentials from `.env` (UI_USERNAME/UI_PASSWORD)

2. **Create Organization**: 
   - Go to Settings → Teams & Organizations
   - Create a new organization

3. **Create Team**:
   - Within the organization, create a team
   - Teams group users with similar access permissions

4. **Create Users**:
   - Add users to teams
   - Each user gets tracked individually

5. **Generate Virtual API Keys**:
   - For each user/team, generate a virtual API key
   - Configure which models the key can access
   - Set spending limits if needed

6. **Configure Open WebUI**:
   - Use the virtual API key when connecting Open WebUI to LiteLLM
   - User information will be automatically forwarded via headers

7. **View Usage**:
   - Check usage per user in LiteLLM UI
   - Export usage data as needed

## Key Features

### Enabled by Default
- User registration and authentication
- Message ratings and community sharing
- Code execution with Pyodide
- Auto-tagging and autocomplete generation
- Evaluation arena models
- Admin export and chat access
- Per-user usage tracking (via `ENABLE_FORWARD_USER_INFO_HEADERS`)

### Available Features (Enable via .env)
- **RAG/Web Search**: Enable `ENABLE_WEB_SEARCH` and configure search provider
- **Image Generation**: Enable `ENABLE_IMAGE_GENERATION` and configure AUTOMATIC1111/ComfyUI
- **GPU Support**: Uncomment GPU configuration in docker-compose.yml
- **Multi-node Deployment**: Configure Redis URLs for websocket support
- **OAuth/SSO**: Configure OAuth providers in .env

### LiteLLM + Open WebUI Integration Features
Based on the [official tutorial](https://docs.litellm.ai/docs/tutorials/openweb_ui):
- **Per-User Usage Tracking**: Track usage and costs per user ID
- **Virtual API Keys**: Create user/team-specific API keys with model access controls
- **Model Access Control**: Limit which models each user/team can access
- **Thinking Content Rendering**: Support for `<think>` tags with merge_reasoning_content
- **100+ LLM Support**: Access models from all major providers through LiteLLM proxy
- **Usage Logging**: Log to external services like Langfuse, S3, GCS
- **Model Fallbacks**: Automatic fallback to alternative models on failure

## Directory Structure

```
.
├── docker-compose.yml      # Service orchestration
├── .env                    # Environment variables (not in git)
├── config/                 # Service configurations
│   ├── litellm/
│   │   └── config.yaml    # Model configurations
│   └── open-webui/        # Custom UI configs
├── volumes/                # Persistent data (not in git)
│   ├── postgres/          # Database files
│   ├── redis/             # Cache data
│   ├── open-webui/        # User data and chats
│   └── cache/             # Model caches
│       ├── embedding/     # Embedding models
│       └── whisper/       # STT models
└── scripts/                # Management scripts
    ├── setup.sh           # Initial setup
    └── backup.sh          # Backup utility
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