# Docker Install

Installs Docker Engine and the Docker Compose plugin from the official Docker apt repository on Ubuntu.

---

## What it does

1. Installs prerequisites (`curl`, `gnupg`, `ca-certificates`)
2. Adds the Docker GPG key and official stable apt repository
3. Installs `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, and `docker-compose-plugin`
4. Verifies the installation by printing the Docker and Compose versions

Supports `amd64`, `arm64`, and `armhf` architectures.

---

## Prerequisites

- Ubuntu server
- Run as **root**
- Internet access to `download.docker.com`

---

## Usage

```bash
chmod +x install.sh
sudo ./install.sh
```

No flags or configuration required — runs non-interactively from start to finish.

---

## After Installation

```bash
# Verify
docker --version
docker compose version

# Service control
systemctl status docker
systemctl restart docker

# Add a user to the docker group (avoids needing sudo)
usermod -aG docker <username>
```
