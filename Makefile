GOBIN ?= ${GOPATH}/bin
IMG   ?= tackle2-addon-windup:latest
CONTAINER_RUNTIME := docker
build-image:
	podman build
	
.PHONY: test-e2e
START_MINIKUBE_SH = ./bin/start-minikube.sh
INSTALL_TACKLE_SH = ./bin/install-tackle.sh
start-minikube:
ifeq (,$(wildcard $(START_MINIKUBE_SH)))
	@{ \
	set -e ;\
	mkdir -p $(dir $(START_MINIKUBE_SH)) ;\
	curl -sSLo $(START_MINIKUBE_SH) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/start-minikube.sh ;\
	chmod +x $(START_MINIKUBE_SH) ;\
	}
endif
	$(START_MINIKUBE_SH);
install-tackle:
ifeq (,$(wildcard $(INSTALL_TACKLE_SH)))
	@{ \
	set -e ;\
	mkdir -p $(dir $(INSTALL_TACKLE_SH)) ;\
	curl -sSLo $(INSTALL_TACKLE_SH) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/install-tackle.sh ;\
	chmod +x $(INSTALL_TACKLE_SH) ;\
	}
endif
	$(INSTALL_TACKLE_SH);

test-e2e: start-minikube build-image install-tackle; \
	$(shell kubectl port-forward service/tackle-ui 8080:8080 -n konveyor-tackle &); \
	export HOST=http://127.0.0.1:8080/hub; \
	bash hack/test-e2e.sh;

.PHONY: test-e2e-without-env-setup
test-e2e-without-env-setup: 
	bash hack/test-e2e.sh
