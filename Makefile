GOBIN ?= ${GOPATH}/bin
IMG   ?= tackle2-addon-windup:latest
CONTAINER_RUNTIME := $(shell command -v podman 2> /dev/null || echo docker)

.PHONY: start-minikube
START_MINIKUBE = ./bin/start-minikube.sh
start-minikube:
	mkdir -p $(dir $(START_MINIKUBE)) ;\
	curl -sSLo $(START_MINIKUBE) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/start-minikube.sh ;\
	chmod +x $(START_MINIKUBE) ;\
	$(START_MINIKUBE);
