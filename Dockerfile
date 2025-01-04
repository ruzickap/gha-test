#checkov:skip=CKV_DOCKER_2
#checkov:skip=CKV_DOCKER_3
FROM --platform=${BUILDPLATFORM} debian:bookworm-slim

ARG TARGETPLATFORM

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL4006
SHELL ["/bin/sh", "-eux", "-c"]

# Update and install the required packages
RUN apt-get update && \
    uname -a && \
    dpkg -l | grep apt && \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then apt-get install -y --no-install-recommends arm-trusted-firmware=2.8.0+dfsg-1 ; fi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installation of the packages
RUN uname -a && dpkg -l | { grep arm-trusted-firmware || true; }

# Set default command to show versions (for verification)
CMD ["bash"]
