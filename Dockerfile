#checkov:skip=CKV_DOCKER_2
#checkov:skip=CKV_DOCKER_3
FROM debian:bookworm-slim@sha256:df52e55e3361a81ac1bead266f3373ee55d29aa50cf0975d440c2be3483d8ed3

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
