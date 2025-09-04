FROM python:3.13-slim AS base

FROM base AS builder
# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.8.15 /uv /bin/uv

# Set uv environment variables
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# Copy application code
COPY . .

# Install the project
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

FROM base
# Copy the virtual environment from the builder stage
COPY --from=builder /app /app

# Set the PATH to use the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Set the working directory
WORKDIR /app

# Expose the Prometheus port
EXPOSE 8000

# Command to run the script
CMD ["python", "metrics.py"]
