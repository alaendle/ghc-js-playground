FROM debian:bookworm-20231009
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      # required for ghcup
      build-essential=12.9 \
      curl=7.88.1-10+deb12u4 \
      libffi-dev=3.4.4-1 \
      libffi8=3.4.4-1 \
      libgmp-dev=2:6.2.1+dfsg1-1.1 \
      libgmp10=2:6.2.1+dfsg1-1.1 \
      libncurses-dev=6.4-4 \
      libncurses5=6.4-4 \
      libtinfo5=6.4-4 \
      # additionally
      ca-certificates=20230311 \
      git=1:2.39.2-1.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG HADOLINT_VERSION=v2.12.0
RUN curl -L -o /bin/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 && \
    chmod a+x /bin/hadolint

ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=yes \
    BOOTSTRAP_HASKELL_NO_UPGRADE=yes \
    BOOTSTRAP_HASKELL_MINIMAL=yes
ENV PATH="/root/.local/bin:/root/.cabal/bin:/root/.ghcup/bin:$PATH"
ARG GHC_VERSION=9.6.3
ARG CABAL_VERSION=3.10.1.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh && \
    ghcup install ghc ${GHC_VERSION} --set && \
    ghcup install cabal ${CABAL_VERSION} --set
