#!/bin/bash
#
#
# Este script realiza toda a configuração necessária para a disponibilização 
# de uma instância do logratate para rotina de limpeza de logs de containres docker.
#
#

if [[ $UID != 0 ]]; then
    tput setaf 3
    echo "Por favor, execute este script com sudo:"
    echo "sudo $0 $*"
    tput setaf 7
    exit 1
fi

configLogrotate() {
  
  tput setaf 2
  echo "-------------------------------------------------------"
  echo "- Configurando o logrotate para os containres docker. -"
  echo "-------------------------------------------------------"
  echo \
	'
	/var/lib/docker/containers/*/*.log {
	  daily
	  dateext
	  rotate 2
	  compress
	  missingok
	  size=1024M
	  copytruncate
	  delaycompress
	}
	' >> /etc/logrotate.d/docker-container
  echo
  tput setaf 3
  echo "-----------------------------------------------------"
  echo "- Arquivo /etc/logrotate.d/docker-container criado. -"
  echo "-----------------------------------------------------"
  tput setaf 7
  echo
  rm -f /var/lib/docker/containers/*/*.log.*
  echo
  tput setaf 2
  echo "-------------------------------------------------------"
  echo "- Logrotate configurado para os containres docker.    -"
  echo "-------------------------------------------------------"
  tput setaf 7
}

case "$1" in
  configLogrotate)
        configLogrotate
        ;;
  *)
        tput setaf 3
        echo $"Usage: sudo $0  {configLogrotate}"
        tput setaf 7
        exit 1
esac