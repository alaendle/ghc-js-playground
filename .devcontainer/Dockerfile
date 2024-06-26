FROM debian:bookworm-20240408
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      # required for ghcup
      build-essential=12.9 \
      curl=7.88.1-10+deb12u5 \
      libffi-dev=3.4.4-1 \
      libffi8=3.4.4-1 \
      libgmp-dev=2:6.2.1+dfsg1-1.1 \
      libgmp10=2:6.2.1+dfsg1-1.1 \
      libncurses-dev=6.4-4 \
      libncurses5=6.4-4 \
      libnuma1=2.0.16-1 \
      libtinfo5=6.4-4 \
      # required for emscripten
      cmake=3.25.1-1 \
      python3=3.11.2-1+b1 \
      # required for ghc
      autoconf=2.71-3 \
      automake=1:1.16.5-1.3 \
      locales-all=2.36-9+deb12u4 \
      # additionally
      ca-certificates=20230311 \
      git=1:2.39.2-1.1 \
      sudo=1.9.13p3-1+deb12u1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG HADOLINT_VERSION=v2.12.0
RUN curl -L -o /bin/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 && \
    chmod a+x /bin/hadolint

# create user

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# install the rest as user
USER $USERNAME

ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=yes \
    BOOTSTRAP_HASKELL_NO_UPGRADE=yes \
    BOOTSTRAP_HASKELL_MINIMAL=yes
ENV PATH=/home/$USERNAME/.local/bin:/home/$USERNAME/.cabal/bin:/home/$USERNAME/.ghcup/bin:$PATH

ARG GHC_VERSION=9.6.4
ARG CABAL_VERSION=3.10.3.0
ARG STACK_VERSION=2.15.5
ARG HLS_VERSION=2.7.0.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh && \
    ghcup install ghc ${GHC_VERSION} --set && \
    ghcup install cabal ${CABAL_VERSION} --set && \
    ghcup install stack ${STACK_VERSION} --set && \
    ghcup install hls ${HLS_VERSION} --set

WORKDIR /home/$USERNAME

ARG EMSCRIPTEN_VERSION=3.1.57
RUN git clone --depth 1 --branch 3.1.57  https://github.com/emscripten-core/emsdk.git && \
    emsdk/emsdk install ${EMSCRIPTEN_VERSION} && \
    emsdk/emsdk activate ${EMSCRIPTEN_VERSION}

ENV EMSDK=/home/$USERNAME/emsdk
ENV EMSDK_NODE=${EMSDK}/node/16.20.0_64bit/bin/node
ENV PATH=${EMSDK}:${EMSDK}/upstream/emscripten:${EMSDK}/node/16.20.0_64bit/bin:${PATH}
ENV LANG=en_US.UTF-8

RUN git clone --depth 1 --branch ghc-9.8.2-release https://gitlab.haskell.org/ghc/ghc.git --recursive
WORKDIR /home/$USERNAME/ghc
RUN cabal update && \
    cabal install \
      alex-3.5.1.0 \
      happy-1.20.1.1 && \
    ./boot && \
    emconfigure ./configure --target=javascript-unknown-ghcjs  && \
    hadrian/build -j12 --flavour=quick --bignum=native --docs=none
