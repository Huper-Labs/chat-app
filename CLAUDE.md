# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI Testing Infrastructure using Docker Compose to run Open WebUI and LiteLLM for unified AI model access. This setup provides a web interface for interacting with multiple LLM providers through a single proxy layer.

## Key Commands

### Service Management
- `./scripts/setup.sh` - Initial setup (creates directories, copies .env template, pulls images)
- `docker-compose up -d` - Start all services
- `docker-compose down` - Stop all services
- `docker-compose logs -f [service]` - View logs (services: open-webui, litellm, postgres, redis)
- `docker-compose pull && docker-compose up -d` - Update to latest versions

### Data Management
- `./scripts/backup.sh` - Full backup of database and volumes
- `docker-compose run --rm postgres pg_dumpall -U postgres` - Manual database backup

### Service URLs
- Open WebUI: http://localhost:3000
- LiteLLM API: http://localhost:4000  
- LiteLLM UI: http://localhost:4000 (login with UI_USERNAME/UI_PASSWORD from .env)

## Architecture & Service Dependencies

```
┌─────────────────┐     ┌─────────────────┐
│   Open WebUI    │────▶│    LiteLLM      │
│   (Port 3000)   │     │   (Port 4000)   │
└────────┬────────┘     └────────┬────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│   PostgreSQL    │     │     Redis       │
│   (Port 5432)   │     │   (Port 6379)   │
└─────────────────┘     └─────────────────┘
```

- **Open WebUI** connects to LiteLLM via OpenAI-compatible API at http://litellm:4000/v1
- **LiteLLM** routes requests to various LLM providers (OpenAI, Anthropic, Google, etc.)
- **PostgreSQL** stores user data, chat history, and model configurations
- **Redis** provides caching for LiteLLM and websocket support for multi-node deployments

## Critical Configuration Files

### `/config/litellm/config.yaml`
Main LiteLLM configuration defining:
- Model list with provider-specific parameters
- Reasoning model support (`merge_reasoning_content_in_choices: true` for o-series, Magistral, etc.)
- Model fallback groups for high availability
- Cache, routing, and retry settings

### `.env` File Structure
Environment variables are prefixed by service:
- `PROVIDER_*_API_KEY` - LLM provider API keys (e.g., PROVIDER_OPENAI_API_KEY)
- `WEBUI_*` - Open WebUI settings
- `LITELLM_*` - LiteLLM proxy settings
- Feature flags: `ENABLE_*` (e.g., ENABLE_WEB_SEARCH, ENABLE_IMAGE_GENERATION)

## Model Configuration Patterns

### Adding New Models
Models are defined in `config/litellm/config.yaml`:
```yaml
- model_name: user-facing-name
  litellm_params:
    model: provider/actual-model-name
    api_key: os.environ/PROVIDER_API_KEY
    # For reasoning models only:
    merge_reasoning_content_in_choices: true
```

### Reasoning Models
These models require `merge_reasoning_content_in_choices: true`:
- OpenAI: o1, o1-mini, o1-pro, o3, o3-pro, o3-mini
- Anthropic: claude-opus-4, claude-sonnet-4, claude-3.5-sonnet
- Mistral: magistral-medium, magistral-small
- Perplexity: sonar-reasoning-pro, sonar-reasoning, r1-1776
- Google: gemini-2.5-pro, gemini-2.5-flash, gemini-2.5-flash-lite
- xAI: All Grok models

## Integration Features

### User Tracking (LiteLLM + Open WebUI)
- Enabled via `ENABLE_FORWARD_USER_INFO_HEADERS=true`
- Headers forwarded: X-OpenWebUI-User-Id
- Allows per-user usage tracking and virtual API keys

### Model Fallbacks
Configured in `router_settings.model_group_alias` - each model has a prioritized fallback list for resilience.

## Common Development Tasks

### Updating Model Lists
1. Edit `config/litellm/config.yaml` to add/modify models
2. Update fallback groups if adding new models
3. Update README.md model documentation
4. Restart LiteLLM: `docker-compose restart litellm`

### Debugging Connection Issues
1. Check API keys in `.env` are correctly prefixed with `PROVIDER_`
2. Verify LiteLLM logs: `docker-compose logs -f litellm`
3. Test direct API access: `curl http://localhost:4000/health`
4. Ensure `drop_params: true` is set in litellm_settings for compatibility