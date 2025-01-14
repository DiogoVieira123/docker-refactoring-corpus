IMAGE_PREFIX ?= platform

.PHONY: all services api worker auth

all: services

services: api worker auth

api:
	docker build -t $(IMAGE_PREFIX)/api:dev services/api

worker:
	docker build -t $(IMAGE_PREFIX)/worker:dev services/worker

auth:
	docker build -t $(IMAGE_PREFIX)/auth:dev services/auth
