#!/bin/bash
COMPOSE_BAKE=true docker compose -f docker/docker-compose.yaml up --remove-orphans --build
