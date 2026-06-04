#!/bin/bash
# ================================================
# Script de entrada do Self-Hosted Runner
# Registra o runner no GitHub e inicia a escuta
# ================================================

# Variáveis obrigatórias (passadas via docker run)
# GITHUB_URL  = URL do seu repositório
# RUNNER_TOKEN = Token gerado no GitHub (Settings > Actions > Runners)

echo "🚀 Iniciando Self-Hosted Runner..."
echo "   Repositório: ${GITHUB_URL}"

# Registra o runner no repositório do GitHub
./config.sh \
    --url "${GITHUB_URL}" \
    --token "${RUNNER_TOKEN}" \
    --name "docker-runner-local" \
    --labels "self-hosted,docker,playwright" \
    --unattended \
    --replace

# Garante que o runner seja removido do GitHub ao desligar o container
cleanup() {
    echo "🛑 Desregistrando runner do GitHub..."
    ./config.sh remove --token "${RUNNER_TOKEN}"
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Inicia o runner e fica escutando por jobs
./run.sh & wait $!
