GOBIN ?= ${GOPATH}/bin
IMG   ?= tackle2-addon-windup:latest
CONTAINER_RUNTIME := $(shell command -v podman 2> /dev/null || echo docker)


.PHONY: test-e2e
START_MINIKUBE = ./bin/start-minikube.sh
INSTALL_TACKLE = ./bin/install-tackle.sh
start-minikube:
	mkdir -p $(dir $(START_MINIKUBE)) ;\
	curl -sSLo $(START_MINIKUBE) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/start-minikube.sh ;\
	chmod +x $(START_MINIKUBE) ;\
	$(START_MINIKUBE);

install-tackle:
	mkdir -p $(dir $(INSTALL_TACKLE)) ;\
	curl -sSLo $(INSTALL_TACKLE) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/install-tackle.sh ;\
	chmod +x $(INSTALL_TACKLE) ;\
	export TACKLE_UI_IMAGE="quay.io/konveyor/tackle2-ui:v2.1.0"; $(INSTALL_TACKLE);
	
test-e2e: start-minikube install-tackle; \
	chmod +x ./hack/test-e2e.sh; \
	./hack/test-e2e.sh; \
	echo "Test E2E";
