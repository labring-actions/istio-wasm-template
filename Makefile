vendor:
	rm -rf .cargo
	cargo vendor --manifest-path Cargo.toml  --respect-source-config
	mkdir -p .cargo && cp config.toml .cargo/


build:target
	rm -rf target
	cargo build --target wasm32-wasi --release
	cp target/wasm32-wasi/release/{{project-name}}.wasm ./plugin.wasm


target:
	rustup target add wasm32-wasi


REPO?=sealos.hub:5000 #reg.
IMG?=wasm/wasm-auth:latest

docker-build:
	docker build -t $(REPO)/$(IMG)  -f Dockerfile   .
	docker push $(REPO)/$(IMG)
	echo $(REPO)/$(IMG) > deploy/images/shim/wasmImage
	sed -i 's#wasm:latest#$(IMG)#g'  deploy/charts/istio-wasm/values.yaml

oci-build:
	sealos build -t $(REPO)/$(IMG)  -f Sealfile   .
	sealos push $(REPO)/$(IMG)
	echo $(REPO)/$(IMG) > deploy/images/shim/wasmImage
	sed -i 's#wasm:latest#$(IMG)#g'  deploy/charts/istio-wasm/values.yaml

sealos-push:
	cd deploy && sealos build -t $(REPO)/$(IMG) .
	sealos push $(REPO)/$(IMG)
