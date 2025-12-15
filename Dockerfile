# Lightweight DevOps tools image based on Alpine
FROM alpine:latest

# Install essential DevOps tools
RUN apk add --no-cache \
    # Container & Kubernetes tools
    kubectl \
    helm \
    # Shell & utilities
    bash \
    curl \
    wget \
    git \
    vim \
    nano \
    neovim \
    # Network & system tools
    netcat-openbsd \
    net-tools \
    iputils \
    dnsmasq \
    bind-tools \
    # JSON/YAML processing
    jq \
    yq \
    # Archive tools
    tar \
    gzip \
    zip \
    unzip \
    # Container tools
    docker-cli \
    # SSL/TLS tools
    openssl \
    # Python for scripting
    python3 \
    py3-pip \
    # Package manager
    npm \
    # Additional utilities
    sudo \
    openssh-client \
    rsync \
    ca-certificates \
    openssl \
    zsh

# Add custom CA certificates
COPY secrets/certs/* /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Install k9s (Kubernetes CLI dashboard)
RUN wget https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz -O /tmp/k9s.tar.gz && \
    tar -xzf /tmp/k9s.tar.gz -C /usr/local/bin && \
    rm /tmp/k9s.tar.gz

# Install Helm plugins and other CLI tools
RUN helm plugin install https://github.com/chartmuseum/helm-push || true

# Install build tools and Neovim dependencies
RUN apk add --no-cache \
    build-base \
    gcc \
    g++ \
    make \
    ripgrep \
    fd \
    tree-sitter

# Copy and run Neovim setup script
COPY config/nvim.sh /tmp/nvim.sh
RUN chmod +x /tmp/nvim.sh

# Copy and run Zsh setup script
COPY config/zsh.sh /tmp/zsh.sh
RUN chmod +x /tmp/zsh.sh

# Create non-root user
RUN addgroup -g 1000 devops && \
    adduser -D -u 1000 -G devops devops && \
    echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Run Neovim setup script as root to prepare directories
RUN /tmp/nvim.sh

# Run Zsh setup script as root
RUN /tmp/zsh.sh

# Set working directory
WORKDIR /workspace

# Set default shell to zsh
ENV SHELL=/bin/zsh

# Switch to non-root user
USER devops

# Print installed tools info
RUN echo "=== DevOps Tools Installed ===" && \
    kubectl version --client --short || true && \
    helm version --short || true && \
    k9s version || true && \
    docker --version || true && \
    git --version && \
    jq --version && \
    yq --version || true

CMD ["/bin/zsh"]
