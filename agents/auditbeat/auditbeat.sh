#!/bin/bash

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

installAuditbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de instalação do auditbeat.                        -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Baixando o auditbeat..."
  curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-6.3.1-amd64.deb
  echo
  echo "Instalando o auditbeat..."
  dpkg -i auditbeat-6.3.1-amd64.deb
  echo
  echo "Renomeando o arquivo auditbeat.yml"
  echo
  mv -v /etc/auditbeat/auditbeat.yml /etc/auditbeat/auditbeat.yml.default
  echo
  echo "Movendo o arquivo auditbeat.yml disponibilizado na instalação."
  mv -v auditbeat.yml /etc/auditbeat/auditbeat.yml
  echo
  echo "Removendo o arquivo auditbeat-6.3.1-amd64.deb utilizado na instalação..."
  rm -f auditbeat-6.3.1-amd64.deb
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de instalação do auditbeat finalizado.                         -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

unistallAuditbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de desinstalação do auditbeat.                     -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Desistalando o auditbeat..."
  apt remove -y auditbeat 
  echo
  echo "Removendo o serviço auditbeat..."
  dpkg -P auditbeat
  rm -rvf /etc/auditbeat
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de desinstalação do auditbeat finalizado.                      -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

configAuditbeat() {

  tput setaf 2
  echo "-----------------------------------------"
  echo "- Configurando os Dashboards no Kibana. -"
  echo "-----------------------------------------"
  auditbeat setup --dashboards
  echo
  tput setaf 3
  echo "--------------------------------------------------------------------------------------------------------------"
  echo "- A configuração do apontamento deve ser realizada no arquivo /etc/auditbeat/auditbeat.yml de forma manual   -"
  echo "--------------------------------------------------------------------------------------------------------------"
  tput setaf 7
}

start() {
  tput setaf 3
  echo
  echo "Iniciando o auditbeat..."
  echo
  service auditbeat start
  echo
  tput setaf 2
  echo "Auditbeat iniciado..."
  echo
  tput setaf 7
}

stop() {
  tput setaf 3
  echo
  echo "Finalizando o auditbeat..."
  echo
  service auditbeat stop
  echo
  tput setaf 1
  echo "Auditbeat finalizado..."
  echo
  tput setaf 7
}

status() {
  service auditbeat status
}

case "$1" in
  installAuditbeat)
        installAuditbeat
        ;;
  unistallAuditbeat)
        unistallAuditbeat
        ;;
  configAuditbeat)
        configAuditbeat
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
        echo $"Usage: sudo $0  {installAuditbeat|unistallAuditbeat|configAuditbeat|start|stop|restart|status}"
        tput setaf 7
        exit 1
esac