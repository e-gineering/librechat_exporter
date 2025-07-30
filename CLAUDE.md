# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LibreChat Exporter is a Python-based monitoring tool that extracts metrics from LibreChat's MongoDB database and exposes them in Prometheus-compatible format. It provides both real-time metrics collection and historical analysis capabilities with Grafana visualization.

## Core Architecture

The system has two primary data paths:

1. **Real-time Monitoring**: `metrics.py` → MongoDB → Prometheus metrics endpoint (port 8000) → Grafana/Prometheus
2. **Historical Analysis**: `export_metrics.py` → MongoDB → MariaDB → Grafana dashboards

### Key Components

- **`metrics.py`**: Main metrics collector that continuously reads from LibreChat's MongoDB and exposes Prometheus metrics
- **`historic-analysis/export_metrics.py`**: Historical data exporter that processes date ranges and stores aggregated data in MariaDB
- **Docker containers**: Multi-service setup supporting MariaDB, Grafana, and development Prometheus instances

### Data Flow

```
MongoDB (LibreChat) → Python Collector → Prometheus Metrics → Grafana Dashboard
                   ↓
              MariaDB (Historical) → Grafana Historical Analysis
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
```bash
# Start MariaDB + Grafana stack
cd historic-analysis && docker-compose up -d

# Export historical data for date range
uv run historic-analysis/export_metrics.py 2024-01-01 2024-12-31

# Access Grafana at http://localhost:3000 (admin/admin)
```

### Testing and Quality Assurance
The project uses GitHub Actions for CI/CD with:
- **Flake8** for code style (max line length: 120)
- **Bandit** for security scanning
- Integration tests across Python 3.9-3.13

## Database Schemas

### MongoDB Collections (LibreChat source data)
- **`messages`**: Chat messages with `user`, `sender`, `model`, `tokenCount`, `createdAt`, `error`, `conversationId`
- **`conversations`**: Chat conversations with timestamps
- **`files`**: Uploaded files metadata  
- **`users`**: Registered user accounts

### MariaDB Tables (Historical analysis)
- **`daily_users`**: Daily unique user counts
- **`daily_messages`**: Daily message and conversation totals
- **`daily_messages_by_model`**: Message counts per AI model per day
- **`daily_tokens_by_model`**: Token usage (input/output) per model per day
- **`daily_errors_by_model`**: Error counts per model per day
- **`weekly_users`**: Weekly unique user aggregations
- **`monthly_users`**: Monthly unique user aggregations

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
- **`historic-analysis/`**: Historical analysis components
  - **`export_metrics.py`**: MongoDB to MariaDB data export
  - **`docker-compose.yml`**: MariaDB + Grafana stack
  - **`mariadb-init/init.sql`**: Database schema definition
  - **`Grafana-Dashboard-template.json`**: Pre-configured dashboard
- **`prometheus-dev/`**: Development Prometheus setup
- **`Dockerfile`**: Multi-stage uv-based container build
- **`pyproject.toml`**: Modern Python package configuration with pinned dependencies

## Technology Stack

- **Python 3.13** (compatible with 3.9+)
- **Core Dependencies**: `pymongo`, `prometheus-client`, `twisted`, `python-dotenv`
- **Historical Analysis**: `mysql-connector-python`
- **Package Management**: `uv` (modern replacement for pip/venv)
- **Deployment**: Docker with multi-arch support (amd64/arm64)