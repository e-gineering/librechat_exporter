# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LibreChat Exporter is a Python-based monitoring tool that extracts metrics from LibreChat's MongoDB database and exposes them in Prometheus-compatible format. It provides real-time metrics collection for monitoring via Prometheus and Grafana.

## Core Architecture

The system provides real-time monitoring:

1. **Real-time Monitoring**: `metrics.py` → MongoDB → Prometheus metrics endpoint (port 8000) → Grafana/Prometheus

### Key Components

- **`metrics.py`**: Main metrics collector that continuously reads from LibreChat's MongoDB and exposes Prometheus metrics
- **Docker containers**: Development setup supporting Prometheus instances

### Data Flow

```
MongoDB (LibreChat) → Python Collector → Prometheus Metrics → Grafana Dashboard
```

## Essential Commands

### Development Setup
```bash
# Install dependencies
uv sync

# Run main metrics exporter (exposes metrics on http://localhost:8000)
uv run metrics.py

# Start development MongoDB
docker run -d -p 127.0.0.1:27017:27017 --name mongo mongo

# Query metrics endpoint
curl -sf http://localhost:8000
```

### Historical Analysis
For historical data analysis, use Prometheus with appropriate retention settings and query historical metrics using PromQL.

### Testing and Quality Assurance
```bash
# IMPORTANT: Run these commands after every code change
uv run ruff check .          # Lint code for style and errors
uv run ruff format .         # Format code consistently
uv run ty                    # Type check (optional but recommended)
```

The project uses GitHub Actions for CI/CD with:
- **Ruff** for code linting and formatting (max line length: 120)
- **Ty** for type checking (allowed to fail in pre-alpha)
- Integration tests across Python 3.9-3.13

### Commit Message Guidelines
Follow conventional commits with **sentence case** formatting:
- ✅ `feat: Add new cost tracking metric`
- ✅ `fix: Resolve MongoDB connection timeout`
- ✅ `perf: Remove heavy dependency for faster startup`
- ❌ `feat: add new cost tracking metric` (lowercase)
- ❌ `FEAT: ADD NEW COST TRACKING METRIC` (all caps)

## Database Schemas

### MongoDB Collections (LibreChat source data)
- **`messages`**: Chat messages with `user`, `sender`, `model`, `tokenCount`, `createdAt`, `error`, `conversationId`
- **`conversations`**: Chat conversations with timestamps
- **`files`**: Uploaded files metadata  
- **`users`**: Registered user accounts

### Historical Data Storage
Historical data is stored in Prometheus with configurable retention periods. Use PromQL queries to analyze trends over time.

## Configuration

### Environment Variables
- **`MONGODB_URI`**: MongoDB connection (default: `mongodb://mongodb:27017/`)
- **`MONGODB_DATABASE`**: Database name (default: `LibreChat`)
- **`LOGGING_LEVEL`**: Log verbosity (default: `info`)
- **`LOGGING_FORMAT`**: Log format string

### Docker Deployment
```yaml
metrics:
  image: ghcr.io/e-gineering/librechat_exporter:main
  networks:
    - librechat
  depends_on:
    - mongodb
  ports:
    - "8000:8000"
  environment:
    - MONGODB_URI=mongodb://mongodb:27017/
    - LOGGING_LEVEL=info
  restart: unless-stopped
```

## Metrics Categories

### Real-time Prometheus Metrics
- **Usage Metrics**: Total messages, conversations, token counts
- **User Activity**: Active users (5min windows), daily/weekly/monthly unique users  
- **Model Performance**: Messages, tokens, and errors per AI model
- **System Health**: Error rates, file uploads, registered users

### Key Metric Types
- **Counters**: `librechat_messages_total`, `librechat_error_messages_total`
- **Gauges**: `librechat_active_users`, `librechat_daily_unique_users`
- **Model-specific**: Per-model breakdowns with `model` label
- **Time-windowed**: 5-minute snapshots for real-time monitoring

## Project Structure

- **`metrics.py`**: Main metrics collector and Prometheus exporter
- **`prometheus-dev/`**: Development Prometheus setup
- **`Dockerfile`**: Multi-stage uv-based container build
- **`pyproject.toml`**: Modern Python package configuration with pinned dependencies

## Technology Stack

- **Python 3.13** (compatible with 3.9+)
- **Core Dependencies**: `pymongo`, `prometheus-client`, `twisted`, `python-dotenv`
- **Historical Analysis**: `mysql-connector-python`
- **Package Management**: `uv` (modern replacement for pip/venv)
- **Deployment**: Docker with multi-arch support (amd64/arm64)