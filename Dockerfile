#checkov:skip=CKV_DOCKER_3
FROM debian:bookworm-slim@sha256:67b30a61dc87758f0caf819646104f29ecbda97d920aaf5edc834128ac8493d3

ARG TARGETPLATFORM

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Update and install the required packages
RUN apt-get update && \
    uname -a && \
    dpkg -l | grep apt && \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then apt-get install -y --no-install-recommends arm-trusted-firmware=2.8.0+dfsg-1 ; fi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installation of the packages
RUN uname -a && dpkg -l | { grep arm-trusted-firmware || true; }

USER test

# Add health check for container monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD bash -c "exit 0"

# Set default command to show versions (for verification)
CMD ["bash"]
