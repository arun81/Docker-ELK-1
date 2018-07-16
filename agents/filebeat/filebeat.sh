#!/bin/bash
#
#
# Este script realiza toda a configuração necessária para a disponibilização de uma instância do filebeat
#
#

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

installFilebeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de instalação do filebeat.                         -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Baixando o filebeat..."
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.1-amd64.deb
  echo
  echo "Instalando o filebeat..."
  dpkg -i filebeat-6.3.1-amd64.deb
  echo
  echo "Renomeando o arquivo filebeat.yml"
  echo
  mv -v /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.original
  echo
  echo "Movendo o arquivo filebeat.yml disponibilizado na instalação."
  mv -v filebeat.yml /etc/filebeat/filebeat.yml
  echo
  echo "Removendo o arquivo filebeat-6.3.1-amd64.deb utilizado na instalação..."
  rm -f filebeat-6.3.1-amd64.deb
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de instalação do filebeat finalizado.                          -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

unistallFilebeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de desinstalação do filebeat.                      -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Desistalando o filebeat..."
  apt remove -y filebeat 
  echo
  echo "Removendo o serviço filebeat..."
  dpkg -P filebeat
  rm -rf /etc/filebeat
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de desinstalação do filebeat finalizado.                       -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

configFilebeat() {
  
  tput setaf 2
  echo "-----------------------------------------"
  echo "- Configurando os Dashboards no Kibana. -"
  echo "-----------------------------------------"
  filebeat setup --dashboards
  echo
  tput setaf 3
  echo "----------------------------------------------------------------------------------------------------------"
  echo "- A configuração do apontamento deve ser realizada no arquivo /etc/filebeat/filebeat.yml de forma manual -"
  echo "----------------------------------------------------------------------------------------------------------"
  tput setaf 7
}

start() {
  tput setaf 3
  echo
  echo "Iniciando o filebeat..."
  echo
  service filebeat start
  echo
  tput setaf 2
  echo "Filebeat iniciado..."
  echo
  tput setaf 7
}

stop() {
  tput setaf 3
  echo
  echo "Finalizando o filebeat..."
  echo
  service filebeat stop
  echo
  tput setaf 1
  echo "Filebeat finalizado..."
  echo
  tput setaf 7
}

status() {
  service filebeat status
}

case "$1" in
  installFilebeat)
        installFilebeat
        ;;
  unistallFilebeat)
        unistallFilebeat
        ;;
  configFilebeat)
        configFilebeat
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
        echo $"Usage: sudo $0  {installFilebeat|unistallFilebeat|configFilebeat|start|stop|restart|status}"
        tput setaf 7
        exit 1
esac