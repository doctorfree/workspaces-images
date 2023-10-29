#!/usr/bin/env bash
set -ex

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
[ -d $HOME ] || mkdir -p $HOME
cp ${SCRIPT_PATH}/kasm-user/.aliases $HOME
cp ${SCRIPT_PATH}/kasm-user/.bashrc $HOME
if [ -d $HOME/.config ]; then
  if [ -d $HOME/.config/autostart ]; then
    cp ${SCRIPT_PATH}/kasm-user/.config/autostart/lazyman.desktop $HOME/.config/autostart
  else
    cp -a ${SCRIPT_PATH}/kasm-user/.config/autostart $HOME/.config
  fi
  if [ -d $HOME/.config/xfce4 ]; then
    tar cf - -C ${SCRIPT_PATH}/kasm-user/.config xfce4 | tar xf - -C $HOME/.config
  else
    cp -a ${SCRIPT_PATH}/kasm-user/.config/xfce4 $HOME/.config
  fi
else
  cp -a ${SCRIPT_PATH}/kasm-user/.config $HOME
fi
if [ -d $HOME/.local ]; then
  if [ -d $HOME/.local/bin ]; then
    cp ${SCRIPT_PATH}/kasm-user/.local/bin/lazyman $HOME/.local/bin
  else
    cp -a ${SCRIPT_PATH}/kasm-user/.local/bin $HOME/.local
  fi
  if [ -d $HOME/.local/share ]; then
    tar cf - -C ${SCRIPT_PATH}/kasm-user/.local share | tar xf - -C $HOME/.local
  else
    cp -a ${SCRIPT_PATH}/kasm-user/.local/share $HOME/.local
  fi
else
  cp -a ${SCRIPT_PATH}/kasm-user/.local $HOME
fi
if [ -d $HOME/Desktop ]; then
  cp ${SCRIPT_PATH}/kasm-user/Desktop/* $HOME/Desktop
else
  cp -a ${SCRIPT_PATH}/kasm-user/Desktop $HOME
fi
if [ -d $HOME/bin ]; then
  cp ${SCRIPT_PATH}/kasm-user/bin/* $HOME/bin
else
  cp -a ${SCRIPT_PATH}/kasm-user/bin $HOME
fi
if [ -d $HOME/.cargo ]; then
  cp ${SCRIPT_PATH}/kasm-user/.cargo/env $HOME/.cargo
else
  cp -a ${SCRIPT_PATH}/kasm-user/.cargo $HOME
fi

chown -R 1000:1000 $HOME/