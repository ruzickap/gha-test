#checkov:skip=CKV_DOCKER_2
#checkov:skip=CKV_DOCKER_3
FROM debian:bookworm-slim@sha256:b4aa902587c2e61ce789849cb54c332b0400fe27b1ee33af4669e1f7e7c3e22f

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

# Set default command to show versions (for verification)
CMD ["bash"]
