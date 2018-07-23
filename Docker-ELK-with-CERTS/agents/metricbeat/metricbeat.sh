#!/bin/bash

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

installMetricbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de instalação do metricbeat.                       -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Baixando o metricbeat..."
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.3.1-amd64.deb
  echo
  echo "Instalando o metricbeat..."
  dpkg -i metricbeat-6.3.1-amd64.deb
  echo
  echo "Renomeando o arquivo metricbeat.yml"
  echo
  mv -v /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.yml.default
  echo
  echo "Movendo o arquivo metricbeat.yml disponibilizado na instalação."
  mv -v metricbeat.yml /etc/metricbeat/metricbeat.yml
  echo
  echo "Habilitando módulo..."
  mv -v /etc/metricbeat/modules.d/system.yml /etc/metricbeat/modules.d/system.yml
  mv -v /etc/metricbeat/modules.d/docker.yml /etc/metricbeat/modules.d/docker.yml
  echo
  echo "Removendo o arquivo metricbeat-6.3.1-amd64.deb utilizado na instalação..."
  rm -f metricbeat-6.3.1-amd64.deb
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de instalação do metricbeat finalizado.                        -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

unistallMetricbeat() {

  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Iniciando o processo de desinstalação do metricbeat.                    -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
  echo
  echo "Desistalando o metricbeat..."
  apt remove -y metricbeat 
  echo
  echo "Removendo o serviço metricbeat..."
  dpkg -P metricbeat
  rm -rvf /etc/metricbeat
  echo
  tput setaf 2
  echo "---------------------------------------------------------------------------"
  echo "- Processo de desinstalação do metricbeat finalizado.                     -"
  echo "---------------------------------------------------------------------------"
  tput setaf 7
}

configMetricbeat() {

  tput setaf 2
  echo "-----------------------------------------"
  echo "- Configurando os Dashboards no Kibana. -"
  echo "-----------------------------------------"
  metricbeat setup --dashboards
  echo
  tput setaf 3
  echo "--------------------------------------------------------------------------------------------------------------"
  echo "- A configuração do apontamento deve ser realizada no arquivo /etc/metricbeat/metricbeat.yml de forma manual -"
  echo "--------------------------------------------------------------------------------------------------------------"
  tput setaf 7
}

start() {
  tput setaf 3
  echo
  echo "Iniciando o metricbeat..."
  echo
  service metricbeat start
  echo
  tput setaf 2
  echo "Metricbeat iniciado..."
  echo
  tput setaf 7
}

stop() {
  tput setaf 3
  echo
  echo "Finalizando o metricbeat..."
  echo
  service metricbeat stop
  echo
  tput setaf 1
  echo "Metricbeat finalizado..."
  echo
  tput setaf 7
}

status() {
  service metricbeat status
}

case "$1" in
  installMetricbeat)
        installMetricbeat
        ;;
  unistallMetricbeat)
        unistallMetricbeat
        ;;
  configMetricbeat)
        configMetricbeat
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
        echo $"Usage: sudo $0  {installMetricbeat|unistallMetricbeat|configMetricbeat|start|stop|restart|status}"
        tput setaf 7
        exit 1
esac