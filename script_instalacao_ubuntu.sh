#!/bin/bash
echo "Script de pós instalação do Ubuntu, por Kesley Fortunato.
É preciso estar logado como root para o funcionamento deste script
Compativel com Ubuntu, Mint, Elementary e todas as distribuições Debian-based.
Versão do script: 1.0.5"
#Funções do script
AddRepositorios(){
  echo "adicionando alguns repositórios para a instalação de alguns pacotes"
  add-apt-repository ppa:plushuang-tw/uget-stable -y
  add-apt-repository ppa:papirus/papirus -y
}
InstalarPacotes(){
  echo "instalando alguns pacotes básicos"
  sudo apt-get install build-essential -y
  sudo apt-get install checkinstall -y
  sudo apt-get install cdbs -y
  sudo apt-get install devscripts -y
  sudo apt-get install dh-make -y
  sudo apt-get install libxml-parser-perl -y
  sudo apt-get install check -y 
  sudo apt-get install preload -y
  sudo apt-get install papirus-icon-theme -y
  sudo apt-get install redshift redshift-gtk -y
  sudo apt install gdebi -y
  sudo apt-get install spotify-client -y
  sudo apt-get install snapd -y
  sudo apt-get install chromium-browser -y
  sudo apt-get install plank -y
  sudo apt-get install mysql-workbench -y
  sudo apt-get install mysql-server -y
  sudo apt-get install shutter -y
  sudo apt-get install filezilla -y
  sudo apt-get install git -y
  sudo apt-get install eclipse -y
}
AtualizarRepo(){
  echo "Atualizando os repositórios"
  sudo apt-get update
}
InstalarJDK8(){
  echo "Instalando o JDK8"
  sudo apt-get install oracle-java8-installer -y
  sudo apt-get install oracle-java8-set-default -y
}
InstalarSnaps(){
  sudo snap install skype --classic
  sudo snap install atom --classic
  sudo snap install vscode --classic
  sudo snap install sublime-text --classic
  sudo snap install spotify
}
function BaixarPacotes() {
  if [[-s "gitkraken-amd64.deb"]]; then
    echo "GitKraken já baixado"
  else
  wget -O gitkraken-amd64.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb
  fi

  if [[-s "eclipse.tar.gz"]]; then
    echo "Eclipse já baixado"
  else
    wget -O eclipse.tar.gz http://mirror.nbtelecom.com.br/eclipse/technology/epp/downloads/release/neon/3/eclipse-jee-neon-3-linux-gtk-x86_64.tar.gz
  fi

  if [[-s "vpn.deb"]]; then
    echo "VPN já baixado"
  else
    wget -O vpn.deb https://file.fh.com.br/index.php/s/wh3Jg7JtrMVbsT8/download
  fi

  if [[-s "chrome.deb"]]; then
    echo "Chrome já baixado"
  else
    wget -O chrome.deb https://file.fh.com.br/index.php/s/qiaJPmYREWvSyg4/download
  fi
  if [[-s "soap.sh"]]; then
    echo "Soap já baixado"
  else
    wget -O soap.sh https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-x64-5.4.0.sh
  fi
  if [[-s "wps-office" ]]; then
    echo "wps-office.deb já baixado"
  else
    wget -O wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
  fi
}
function InstalarPacotesDeb() {
  echo y | gdebi gitkraken-amd64.deb
  echo y | gdebi vpn.deb
  echo y | gdebi chrome.deb
  echo y | gdebi wps-office.deb
  tar xvzf eclipse.tar.gz -C /opt/
  chmod +x soap.sh
  ./soap.sh
}
if [[ $UID != 0 ]]; then
    echo "Necessário root para executar o script. Utilize o seguinte comando:"
    echo "sudo $0 $*"
    exit 1
else
# Adicionar repositórios
AddRepositorios
clear
# Atualizar repositórios
echo "Repositórios [OK]"
AtualizarRepo
clear
#Instalar pacotes
echo "Repositórios [OK]"
echo "Atualização dos repositórios [OK]"
InstalarPacotes
clear
#Instalar Mailspring, skype e VLC
echo "Repositórios [OK]"
echo "Atualização dos repositórios [OK]"
echo "Instalação dos pacotes [OK]"
InstalarSnaps
BaixarPacotes
InstalarPacotesDeb
clear
# Atualização do Sistema
echo "Repositórios [OK]"
echo "Atualização dos repositórios [OK]"
echo "Instalação dos pacotes [OK]"
echo "Repositórios [OK]"
echo "Atualização dos repositórios [OK]"
echo "Instalação dos deb [OK]"
sudo apt-get dist-upgrade -y
sudo apt autoremove -y
clear
echo "Tudo instalado! Obrigado por usar meu script (:"
fi