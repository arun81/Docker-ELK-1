#!/bin/bash

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

installPacketbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de instalação do packetbeat.                       -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Baixando o packetbeat..."
  curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.3.1-amd64.deb
  echo
  echo "Instalando o packetbeat..."
  dpkg -i packetbeat-6.3.1-amd64.deb
  echo
  echo "Renomeando o arquivo packetbeat.yml"
  echo
  mv -v /etc/packetbeat/packetbeat.yml /etc/packetbeat/packetbeat.yml.default
  echo
  echo "Movendo o arquivo packetbeat.yml disponibilizado na instalação."
  mv -v packetbeat.yml /etc/packetbeat/packetbeat.yml
  echo
  echo "Removendo o arquivo packetbeat-6.3.1-amd64.deb utilizado na instalação..."
  rm -f packetbeat-6.3.1-amd64.deb
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de instalação do packetbeat finalizado.                        -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

unistallPacketbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de desinstalação do packetbeat.                     -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Desistalando o packetbeat..."
  apt remove -y packetbeat 
  echo
  echo "Removendo o serviço packetbeat..."
  dpkg -P packetbeat
  rm -rvf /etc/packetbeat
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de desinstalação do packetbeat finalizado.                     -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

configPacketbeat() {

  tput setaf 2
  echo "-----------------------------------------"
  echo "- Configurando os Dashboards no Kibana. -"
  echo "-----------------------------------------"
  packetbeat setup --dashboards
  echo
  tput setaf 3
  echo "--------------------------------------------------------------------------------------------------------------"
  echo "- A configuração do apontamento deve ser realizada no arquivo /etc/packetbeat/packetbeat.yml de forma manual  -"
  echo "--------------------------------------------------------------------------------------------------------------"
  tput setaf 7
}

start() {
  tput setaf 3
  echo
  echo "Iniciando o packetbeat..."
  echo
  service packetbeat start
  echo
  tput setaf 2
  echo "Packetbeat iniciado..."
  echo
  tput setaf 7
}

stop() {
  tput setaf 3
  echo
  echo "Finalizando o packetbeat..."
  echo
  service packetbeat stop
  echo
  tput setaf 1
  echo "Packetbeat finalizado..."
  echo
  tput setaf 7
}

status() {
  service packetbeat status
}

case "$1" in
  installPacketbeat)
        installPacketbeat
        ;;
  unistallPacketbeat)
        unistallPacketbeat
        ;;
  configPacketbeat)
        configPacketbeat
        ;;
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
    stop
        sleep 15
    start
        ;;
  status)
        status
        ;;
  *)
        tput setaf 3
        echo $"Usage: sudo $0  {installPacketbeat|unistallPacketbeat|configPacketbeat|start|stop|restart|status}"
        tput setaf 7
        exit 1
esac