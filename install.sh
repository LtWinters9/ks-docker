#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Docker Install — installs Docker Engine + Docker Compose plugin.
# ─────────────────────────────────────────────────────────────────────────────

DOCKER_GPG_KEY="/etc/apt/keyrings/docker.gpg"
DOCKER_REPO_LIST="/etc/apt/sources.list.d/docker.list"

# ─────────────────────────────────────────────────────────────────────────────

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────

check_root() {
    [[ $EUID -eq 0 ]] || die "Must be run as root."
}

check_arch() {
    ARCH="$(dpkg --print-architecture)"
    case "$ARCH" in
        amd64|arm64|armhf) ;;
        *) die "Unsupported architecture: $ARCH" ;;
    esac
    log "Architecture: $ARCH"
}

add_repo() {
    log "Installing prerequisites..."
    apt-get -qq install -y \
        ca-certificates \
        curl \
        gnupg

    log "Adding Docker GPG key..."
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" \
        | gpg --dearmor -o "$DOCKER_GPG_KEY"
    chmod a+r "$DOCKER_GPG_KEY"

    log "Adding Docker repo..."
    echo \
        "deb [arch=${ARCH} signed-by=${DOCKER_GPG_KEY}] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" \
        | tee "$DOCKER_REPO_LIST" > /dev/null

    apt-get -qq update
}

install_docker() {
    log "Installing Docker Engine and Compose plugin..."
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
}

verify_install() {
    log "Verifying installation..."
    docker --version
    docker compose version
    log "Docker service status: $(systemctl is-active docker)"
}

# ─────────────────────────────────────────────────────────────────────────────

main() {
    check_root
    check_arch

    log "─── Docker install started on ${HOSTNAME} ───"
    add_repo
    install_docker
    verify_install
    log "Docker installed successfully on ${HOSTNAME}."
    log "Tip: add a user to the docker group with: usermod -aG docker <username>"
}

main
