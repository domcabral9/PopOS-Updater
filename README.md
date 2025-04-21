# 🛠️ popos-updater.sh - Atualizador para Pop!_OS

Script de shell criado para automatizar a atualização, limpeza e verificação de saúde do sistema Pop!_OS (20.04 LTS ou superior) em um ambiente de homelab.

## 🌟 Objetivo

- Atualizar pacotes APT e Flatpak
- Verificar conectividade com a internet
- Verificar o uso de disco da partição raiz
- Limpar pacotes e arquivos desnecessários
- Notificar no desktop ao finalizar (opcional)
- Registrar logs em `/var/logs/popos-updater_*`

## ▶️ Como usar

```bash
chmod +x popos-updater.sh
sudo ./popos-updater.sh [--verbose]
```

- `--verbose`: Exibe a saída dos comandos em tempo real.

---

# 🛠️ popos-updater.sh - Updater for Pop!_OS

Shell script created to automate system update, cleanup, and health check on Pop!_OS (20.04 LTS or newer), mainly for homelab use.

## 🌟 Objective

- Update APT and Flatpak packages
- Check internet connectivity
- Monitor disk usage of `/` partition
- Clean unnecessary packages and cache
- Send optional desktop notification on finish
- Log output to `/var/logs/popos-updater_*`

## ▶️ Usage

```bash
chmod +x popos-updater.sh
sudo ./popos-updater.sh [--verbose]
```

- `--verbose`: Print command output to terminal in real time.


