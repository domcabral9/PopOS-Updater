#!/usr/bin/env bash
#
# popos-updater.sh - Atualizador e otimizador de pacotes para Pop!_OS (20.04 LTS ou superior)
# Desenvolvido por: domcabral9
# Contato: domcabral@proton.me
#
# COMO USAR?
#   $ chmod +x popos-updater.sh
#   $ ./popos-updater.sh [--verbose]

# ----------------------------- VARIÁVEIS ----------------------------- #

# Cores para mensagens no terminal
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
AMARELO='\e[1;93m'
SEM_COR='\e[0m'

# Diretório e nome do arquivo de log com data e hora
LOG_DIR="/var/logs"
mkdir -p "$LOG_DIR"
DATA=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/popos-updater_$DATA.log"

# Flag para modo verboso
VERBOSE=false
if [[ "$1" == "--verbose" ]]; then
  VERBOSE=true
fi

# ----------------------------- FUNÇÕES ----------------------------- #

# Exibir mensagens coloridas e salvar no log
exibir_mensagem() {
  local tipo="$1"
  local mensagem="$2"

  case "$tipo" in
    "INFO") echo -e "${VERDE}[INFO] - $mensagem${SEM_COR}" ;;
    "WARNING") echo -e "${AMARELO}[WARNING] - $mensagem${SEM_COR}" ;;
    "ERROR") echo -e "${VERMELHO}[ERROR] - $mensagem${SEM_COR}" ;;
  esac
  echo "[$tipo] - $mensagem" >> "$LOG_FILE"
}

# Notificação de desktop (se disponível)
enviar_notificacao() {
  if command -v notify-send &>/dev/null; then
    notify-send "Atualização do sistema" "$1"
  fi
}

# Verificar se o script está sendo executado como root
verificar_permissao() {
  if [[ "$EUID" -ne 0 ]]; then
    exibir_mensagem "ERROR" "Este script precisa ser executado como root. Use sudo."
    exit 1
  fi
}

# Verificar conectividade com a Internet
verificar_internet() {
  if ! curl -s http://google.com &> /dev/null; then
    exibir_mensagem "ERROR" "Seu computador não tem conexão com a Internet. Verifique a rede."
    exit 1
  else
    exibir_mensagem "INFO" "Conexão com a Internet funcionando normalmente."
  fi
}

# Verificar espaço em disco da raiz
verificar_espaco_disco() {
  USO_DISCO=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
  if [ "$USO_DISCO" -ge 85 ]; then
    exibir_mensagem "WARNING" "Cuidado, realizar revisão de dados, volume quase cheio ($USO_DISCO% usado)."
  else
    exibir_mensagem "INFO" "Volume ok por enquanto ($USO_DISCO% usado)."
  fi
}

# Remover travas do apt
remover_travas_apt() {
  rm -f /var/lib/dpkg/lock-frontend
  rm -f /var/cache/apt/archives/lock
}

# Atualização do sistema e Flatpak
atualizar_sistema() {
  exibir_mensagem "INFO" "Iniciando atualização de pacotes e Flatpak..."
  if $VERBOSE; then
    sudo apt update && sudo apt upgrade -y && flatpak update -y | tee -a "$LOG_FILE"
  else
    { sudo apt update && sudo apt upgrade -y && flatpak update -y; } >> "$LOG_FILE" 2>&1
  fi
}

# Limpeza do sistema
limpeza_sistema() {
  exibir_mensagem "INFO" "Executando limpeza do sistema..."
  if $VERBOSE; then
    sudo apt autoclean -y && sudo apt autoremove -y | tee -a "$LOG_FILE"
  else
    { sudo apt autoclean -y && sudo apt autoremove -y; } >> "$LOG_FILE" 2>&1
  fi
}

# ----------------------------- EXECUÇÃO ----------------------------- #

verificar_permissao
remover_travas_apt
verificar_internet
verificar_espaco_disco
atualizar_sistema
limpeza_sistema

exibir_mensagem "INFO" "Script finalizado, atualização concluída! :)"
enviar_notificacao "Atualização concluída com sucesso."
exit 0

