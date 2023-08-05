vendor:
	rm -rf .cargo
	cargo vendor --manifest-path Cargo.toml  --respect-source-config
	mkdir -p .cargo && cp config.toml .cargo/


define find_wasm_files
$(shell find $(1) -name "*.wasm")
endef

build:target
	rm -rf target
	cargo build --target wasm32-wasi --release
	@echo "Searching for .wasm files..."
	$(eval WASM_FILE := $(shell find target/wasm32-wasi/release -name "*.wasm" -print -quit))
	@if [ -n "$(WASM_FILE)" ]; then \
		echo "Found .wasm file: $(WASM_FILE)"; \
		cp $(WASM_FILE) ./plugin.wasm ; \
	else \
		echo "No .wasm file found."; \
	fi


target:
	rustup target add wasm32-wasi


REPO?=sealos.hub:5000 #reg.
IMG?=wasm/wasm-auth:latest

docker-build:
	docker build -t $(REPO)/$(IMG)  -f Dockerfile   .
	docker push $(REPO)/$(IMG)
	echo $(REPO)/$(IMG) > deploy/images/shim/wasmImage
	sed -i 's#wasm:latest#$(IMG)#g'  deploy/charts/istio-wasm/values.yaml