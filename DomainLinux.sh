#!/bin/bash

# Este script foi criado para inserir uma máquina no dominio.
echo -e "\nNecessário logar como sudo!"
sudo -v

sudo apt-get update -y

if ! $(sudo which realmd 2>/dev/null); then
    sudo apt-get install realmd adcli sssd -y
fi

if ! $(sudo which ntpd 2>/dev/null); then
    sudo apt-get install ntp -y
fi

sudo mkdir -p /var/lib/samba/private

echo -e "\n\nQual endereço do dominio: "
read DOMAIN

echo -e "\n\nEntre com admin do Dominio: "
read ADMIN

sudo realm join --user=$ADMIN $DOMAIN

if [ $? -ne 0 ]; then
    echo -e "\n\nAcesso ao AD deu errado. Nada feito, tente novamente!"
    exit 1
    #Caso acesso ao dominio não de certo nada será feito.
fi


sudo systemctl enable sssd
sudo systemctl start sssd

echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0022" | sudo tee -a /etc/pam.d/common-session
echo -e "\n Arquivo /etc/pam.d/common-session alterado."

#Configure sudo
sudo apt-get install libsss-sudo
echo "%domain\ admins@$DOMAIN ALL=(ALL) ALL" | sudo tee -a /etc/sudoers.d/domain_admins
echo -e "\n Arquivo /etc/sudoers.d/domain_admins alterado."

echo -e "[active-directory] \nos-name = Ubuntu Linux \nos-version = 16.04 \n\n[service] \nautomatic-install = yes \n\n[users] \ndefault-home = /home/%u \ndefault-shell = /bin/bash \n\n[$DOMAIN] \nuser-principal = yes \nfully-qualified-names = no" | sudo tee -a /etc/realmd.conf
echo -e "\n Arquivo /etc/realmd.conf alterado."

sudo realm permit -R $DOMAIN -g domain\ users
echo -e "\n Realm permit executado."

echo -e "allow-guest=false \ngreeter-show-manual-login=true" | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
echo -e "\n Arquivo /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf alterado."

echo -e "\n\nNotebook configurado com sucesso no dominio."

#Script para configuração de rede e sudo
CriaPastas() {

  mkdir ~/.netconfigoriginal

}



 BackupParametrosOriginais() {
   if [[ -s "interfaces" ]]; then
     echo "Backup não pode ser sobreescrevido"
  else
    cp /etc/network/interfaces ~/.netconfigoriginal
   fi

  if [[ -s "NetworkManager.conf" ]]; then
    echo "Backup não pode ser sobreescrevido"
  else
    cp /etc/NetworkManager/NetworkManager.conf ~/.netconfigoriginal
  fi

  if [[ -s "base" ]]; then
    echo "Backup não pode ser sobreescrevido"
  else
      cp /etc/resolvconf/resolv.conf.d/base ~/.netconfigoriginal
  fi

  if [[ -s "sssd.conf" ]]; then
    echo "Backup não pode ser sobreescrevido"
  else
      cp /etc/sssd/sssd.conf ~/.netconfigoriginal
  fi




}

 Ethernet() {

  ifconfig | cut -f 1 -d " " > eternet.txt

  read -r eth < eternet.txt
  echo $eth

}

 EditarArquivos() {

  echo -e "# interfaces(5) file used by ifup(8) and ifdown(8)\nauto lo\niface lo inet loopback\n#auto ${eth}\n#iface ${eth} inet dhcp" > /etc/network/interfaces

  sed -i '3s/.*/#dns=dnsmasq/' /etc/NetworkManager/NetworkManager.conf

  echo -e 'nameserver 172.16.0.1\nnameserver 172.16.0.2' > /etc/resolvconf/resolv.conf.d/base

  sed -i '4s/.*/enabled=0/' /etc/default/apport
  sed -i '16s/.*/use_fully_qualified_names = False/' /etc/sssd/sssd.conf

  sed -i '17s/.*/fallback_homedir = \/home\/%u/' /etc/sssd/sssd.conf






}

 Services() {

  sudo service NetworkManager restart

  sudo service sssd restart

}


if [[ $UID != 0 ]]; then

    echo "Necessário root para executar o script. Utilize o seguinte comando:"

    echo "sudo $0 $*"

    exit 1

else

  CriaPastas

  BackupParametrosOriginais
  Ethernet

  EditarArquivos
  Services

  echo "Digite o nome do usuário da máquina: "

  read USUARIO

  sudo usermod -aG sudo $USUARIO
  sed -i "21s/.*/${USUARIO} ALL=(ALL:ALL) ALL/" /etc/sudoers

fi

#sed -i 'Ns/.*/replacement-line/' file.txt                        Exemplo de comando para editar a linha no mesmo arquivo. Onde N é o numero da linha



#awk 'NR==4 {$0="#DHCP"} 1' text.txt > text2.txt                  exemplo de comando para editar detarminada linha em arquivo.


if [ "$OPCAO" == "S" ]; then
        sudo reboot
fi

exit 0
