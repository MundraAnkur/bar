GOBIN ?= ${GOPATH}/bin

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
	CONTROLLER_GEN=$(GOBIN)/controller-gen
else
	CONTROLLER_GEN=$(shell which controller-gen)
endif
