FROM ghcr.io/mazgi/provisioning

# Set in non-interactive mode.
ARG DEBIAN_FRONTEND=noninteractive

ARG DOCKER_GID
ARG GID=0
ARG UID=0
ENV DOCKER_GID=${DOCKER_GID}
ENV GID=${GID:-0}
ENV UID=${UID:-0}

COPY rootfs /
RUN :\
  && cd /usr/local/bin\
  && ln -fs echo-with-color.zsh echoDebug\
  && ln -fs echo-with-color.zsh echoInfo\
  && ln -fs echo-with-color.zsh echoWarn\
  && ln -fs echo-with-color.zsh echoErr\
  && :

HEALTHCHECK --interval=2s --timeout=1s --retries=2 --start-period=5s\
 CMD jq -e ". | select(.succeeded)" $(docker-util.keep-running.zsh --print-status-file-path)

RUN :\
  # Create the development user with the same UID and GID as you.
  && useradd --comment '' --create-home --gid users --uid ${UID} developer\
  && groupadd --gid ${GID} developer || true\
  && usermod --append --groups ${GID} developer || true\
  # Append docker group
  && bash -c "test -n \"${DOCKER_GID}\" && groupadd --gid ${DOCKER_GID} docker"\
  && usermod --append --groups docker developer 2> /dev/null || true\
  && echo '%users ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/grant-all-without-password-to-users\
  && echo '%developer ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/grant-all-without-password-to-developer\
  && :
