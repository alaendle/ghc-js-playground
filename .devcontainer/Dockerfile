FROM debian:bookworm-20231009
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates=20230311 \
      curl=7.88.1-10+deb12u4 \
      git=1:2.39.2-1.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG HADOLINT_VERSION=v2.12.0
RUN curl -L -o /bin/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 && \
    chmod a+x /bin/hadolint
