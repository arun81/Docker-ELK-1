#!/bin/bash

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

installHeartbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de instalação do heartbeat.                        -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Baixando o heartbeat..."
  curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.3.1-amd64.deb
  echo
  echo "Instalando o heartbeat..."
  dpkg -i heartbeat-6.3.1-amd64.deb
  echo
  echo "Renomeando o arquivo heartbeat.yml"
  echo
  mv -v /etc/heartbeat/heartbeat.yml /etc/heartbeat/heartbeat.yml.default
  echo
  echo "Movendo o arquivo heartbeat.yml disponibilizado na instalação."
  mv -v heartbeat.yml /etc/heartbeat/heartbeat.yml
  echo
  echo "Removendo o arquivo heartbeat-6.3.1-amd64.deb utilizado na instalação..."
  rm -f heartbeat-6.3.1-amd64.deb
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de instalação do heartbeat finalizado.                         -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

unistallHeartbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de desinstalação do heartbeat.                     -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Desistalando o heartbeat..."
  apt remove -y heartbeat 
  echo
  echo "Removendo o serviço heartbeat..."
  dpkg -P heartbeat
  rm -rvf /etc/heartbeat
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de desinstalação do heartbeat finalizado.                      -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

configHeartbeat() {

  tput setaf 2
  echo "-----------------------------------------"
  echo "- Configurando os Dashboards no Kibana. -"
  echo "-----------------------------------------"
  heartbeat setup --dashboards
  echo
  tput setaf 3
  echo "--------------------------------------------------------------------------------------------------------------"
  echo "- A configuração do apontamento deve ser realizada no arquivo /etc/heartbeat/heartbeat.yml de forma manual   -"
  echo "--------------------------------------------------------------------------------------------------------------"
  tput setaf 7
}

start() {
  tput setaf 3
  echo
  echo "Iniciando o heartbeat..."
  echo
  service heartbeat start
  echo
  tput setaf 2
  echo "Heartbeat iniciado..."
  echo
  tput setaf 7
}

stop() {
  tput setaf 3
  echo
  echo "Finalizando o heartbeat..."
  echo
  service heartbeat stop
  echo
  tput setaf 1
  echo "Heartbeat finalizado..."
  echo
  tput setaf 7
}

status() {
  service heartbeat status
}

case "$1" in
  installHeartbeat)
        installHeartbeat
        ;;
  unistallHeartbeat)
        unistallHeartbeat
        ;;
  configHeartbeat)
        configHeartbeat
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
        echo $"Usage: sudo $0  {installHeartbeat|unistallHeartbeat|configHeartbeat|start|stop|restart|status}"
        tput setaf 7
        exit 1
esac