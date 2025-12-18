# Project Dev Environment

This project uses Docker Compose to manage multiple services. The Makefile provides convenient commands to build, run, and manage the containers.

## Prerequisites

- Docker >= 20.x
- Docker Compose >= 2.x
- Make

## Quick Start

### Initial Setup

Before starting the containers, create the necessary directories:

```bash
make setup
```

This command creates:
- `data/maildev` - MailDev service data
- `data/portainer` - Portainer service data
- `data/jmeter` - JMeter service data
- `logs` - Applications logs
- `secrets` - Secrets and certificates
- `secrets/certs` - SSL certificates
- `secrets/.kube` - Kubernetes config
- `secrets/.ssh` - SSH keys

### Build and Starting Services

```bash
make install
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make setup` | Initialize project directories |
| `make install` | Build and start all services |
| `make build` | Build all container images |
| `make up` | Start all services in detached mode |
| `make down` | Stop and remove all containers |
| `make logs` | View service logs |
| `make ps` | List running containers |
| `make clean` | Remove containers and volumes |

For more details, run `make help` or check the Makefile.
