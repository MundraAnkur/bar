GOBIN ?= ${GOPATH}/bin
IMG   ?= tackle2-addon-windup:latest
CONTAINER_RUNTIME := $(shell command -v podman 2> /dev/null || echo docker)

build-image:
	echo "Ankur building image $(IMG)";
	
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
	export TACKLE_UI_IMAGE="quay.io/konveyor/tackle2-ui:v2.1.0"; $(INSTALL_TACKLE_SH);
	
test-e2e: start-minikube build-image install-tackle; \
	export HOST=http://$(shell minikube ip)/hub; \
	chmod +x hack/test-e2e.sh; \
	echo "$(HOST)"; \
	bash hack/test-e2e.sh;
	
.PHONY: controller-gen
controller-gen:
ifeq (, $(shell which controller-gen))
	@{ \
	set -e ;\
	CONTROLLER_GEN_TMP_DIR=$$(mktemp -d) ;\
	cd $$CONTROLLER_GEN_TMP_DIR ;\
	go mod init tmp ;\
	go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.5.0 ;\
	rm -rf $$CONTROLLER_GEN_TMP_DIR ;\
	echo $(shell which controller-gen); \
	}
endif
	export CONTROLLER_GEN=$(shell which controller-gen)
