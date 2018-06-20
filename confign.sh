#!/bin/bash
CriaPastas() {

  mkdir ~/.netconfigoriginal

}



 BackupParametrosOriginais() {

  cp /etc/network/interfaces ~/.netconfigoriginal

  cp /etc/NetworkManager/NetworkManager.conf ~/.netconfigoriginal

  cp /etc/resolvconf/resolv.conf.d/base ~/.netconfigoriginal



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
