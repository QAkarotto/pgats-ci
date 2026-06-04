# ================================================
# Self-Hosted GitHub Actions Runner com Playwright
# ================================================

FROM ubuntu:22.04

# Evita perguntas interativas durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências do sistema operacional
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    sudo \
    tar \
    unzip \
    wget \
    # Dependências do Playwright/Chromium
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libxshmfence1 \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js 24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs

# Ativa Corepack (gerenciador do Yarn)
RUN corepack enable

# Cria um usuário chamado "runner" (não root, mais seguro)
RUN useradd -m runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cria a pasta onde o runner vai ficar
WORKDIR /home/runner/actions-runner

# Baixa a versão mais recente do GitHub Actions Runner
RUN RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/v//') \
    && curl -o actions-runner.tar.gz -L \
       "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" \
    && tar xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# Instala dependências do runner
RUN ./bin/installdependencies.sh

# Copia e dá permissão de execução ao entrypoint (ainda como root)
COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh

# Dá permissão ao usuário runner sobre toda a pasta home
RUN chown -R runner:runner /home/runner

# Só agora troca para o usuário runner
USER runner

ENTRYPOINT ["/home/runner/entrypoint.sh"]