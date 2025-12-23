# Dockerfile for Cursor CLI Agent
# This image installs the Cursor CLI during build by default.
# Set INSTALL_CURSOR=false to skip installation and install manually later.

FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set build argument for Cursor installation
ARG INSTALL_CURSOR=true

# Install Cursor CLI if requested
RUN if [ "$INSTALL_CURSOR" = "true" ]; then \
    echo "Installing Cursor CLI..." && \
    curl https://cursor.com/install -fsS | bash || \
    (echo "Warning: Cursor CLI installation failed. You can install it manually later." && exit 0); \
    else \
    echo "Skipping Cursor CLI installation (INSTALL_CURSOR=false)"; \
    fi

# Add local bin to PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy entrypoint scripts
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker/docker-entrypoint-interactive.sh /usr/local/bin/docker-entrypoint-interactive.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint-interactive.sh

# Set working directory
WORKDIR /workspace

# Default command (will be overridden by docker-compose)
CMD ["bash", "-c", "tail -f /dev/null"]

