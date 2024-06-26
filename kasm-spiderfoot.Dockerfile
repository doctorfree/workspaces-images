ARG BASE_TAG="ubuntu-focal"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV LAUNCH_URL  http://127.0.0.1:5002
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND=noninteractive \
    SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/ubuntu/install/spiderfoot/install_spiderfoot.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# SpiderFoot startup is done in the postinstall script and as an autostart desktop entry
# COPY ./src/ubuntu/install/spiderfoot/custom_startup.sh $STARTUPDIR/custom_startup.sh
# RUN chmod +x $STARTUPDIR/custom_startup.sh
# RUN chmod 755 $STARTUPDIR/custom_startup.sh

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  rm -rf ${HOME}/.mozilla && \
  bash $INST_DIR/ubuntu/install/install_kasm_user.sh spiderfoot && \
  cp /usr/share/backgrounds/Owl-02.png $HOME/.local/share/backgrounds/bg_default.png && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user

# Userspace Runtime
ENV HOME /home/kasm-default-profile
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"
WORKDIR $HOME
USER 1000

RUN bash ${INST_DIR}/ubuntu/install/focal/install_user_utils.sh

######### End Customizations ###########

USER root

RUN update-desktop-database && \
    rm -Rf ${INST_DIR}

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
