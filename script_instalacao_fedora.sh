#!/bin/bash

function AtualizarSistema() {
  dnf update -y
}
function InstalarApps() {
  dnf install -y preload
  dnf install -y clang
  dnf install -y vlc
  dnf install -y chromium
  dnf install -y vim
  dnf install -y deluge
  dnf install -y gnome-pie
  dnf install -y snapd
  dnf install -y flatpak
  dnf install -y code
  dnf install -y uget
}
function InstalarSnaps() {
  snap install mailspring
  snap install spotify
}
function Repositorios() {
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}
function AtualizarRepo() {
  dnf check-update
}

if [[ $UID != 0 ]]; then
    echo "Necessário root para executar o script. Utilize o seguinte comando:"
    echo "sudo $0 $*"
    exit 1
else
  Repositorios
  AtualizarRepo
  AtualizarSistema
  InstalarApps
  InstalarSnaps
fi
