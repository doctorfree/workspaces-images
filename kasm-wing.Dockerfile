ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-jammy"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND=noninteractive \
    SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/ubuntu/install/tools/install_tools_deluxe.sh \
                  /ubuntu/install/misc/install_tools.sh \
                  /ubuntu/install/chrome/install_chrome.sh \
                  /ubuntu/install/chromium/install_chromium.sh \
                  /ubuntu/install/firefox/install_firefox.sh \
                  /ubuntu/install/sublime_text/install_sublime_text.sh \
                  /ubuntu/install/vs_code/install_vs_code.sh \
                  /ubuntu/install/nextcloud/install_nextcloud.sh \
                  /ubuntu/install/remmina/install_remmina.sh \
                  /ubuntu/install/only_office/install_only_office.sh \
                  /ubuntu/install/signal/install_signal.sh \
                  /ubuntu/install/gimp/install_gimp.sh \
                  /ubuntu/install/zoom/install_zoom.sh \
                  /ubuntu/install/obs/install_obs.sh \
                  /ubuntu/install/ansible/install_ansible.sh \
                  /ubuntu/install/terraform/install_terraform.sh \
                  /ubuntu/install/telegram/install_telegram.sh \
                  /ubuntu/install/thunderbird/install_thunderbird.sh \
                  /ubuntu/install/gamepad_utils/install_gamepad_utils.sh \
                  /ubuntu/install/wing/install_tools_wing.sh \
                  /ubuntu/install/backgrounds/install_backgrounds.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  rm -rf ${HOME}/.mozilla && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh wing && \
  mkdir -p ${HOME}/.local && \
  mkdir -p ${HOME}/.local/share && \
  mkdir -p ${HOME}/.local/share/fonts && \
  wget -O /tmp/fonts.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/fonts/JetBrainsMonoNerdFont.tar.gz && \
  tar xzf /tmp/fonts.tar.gz \
    -C ${HOME}/.local/share/fonts && \
  rm -f /tmp/fonts.tar.gz && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  rm -Rf ${INST_DIR}

# Publishing this port in docker_run_config enables browser access to
# Wing console from outside the container - http://<ip-address>:3000
EXPOSE 3000

# Userspace Runtime
ENV HOME /home/kasm-user
WORKDIR $HOME
USER 1000

CMD ["--tail-log"]
