# istio-wasm-template

## About

This template is designed for compiling Rust libraries into Istio Wasm and
publishing the resulting package to OCI registry.

> WasmPlugins provides a mechanism to extend the functionality provided by the Istio proxy through WebAssembly filters.

Be sure to using WasmPlugins for istio 1.11 or later.

**Tutorials**: https://istio.io/latest/docs/reference/config/proxy_extensions/wasm-plugin/

**Rust-SDK**: https://github.com/proxy-wasm/proxy-wasm-rust-sdk

## 🚴 Usage

### 🐑 Use `cargo generate` to Clone this Template

[Learn more about `cargo generate` here.](https://github.com/ashleygwilliams/cargo-generate)

```
cargo generate --git https://github.com/labring-actions/istio-wasm-template.git --name my-project
cd my-project
```

### 🛠️ Build with `cargo build`

```
make build
```

### 🔭 Upload vendor

```
make vendor
```


### 🎁 Build to OCI with docker

```
REPO=sealos.hub:5000 IMG=wasm/wasm-auth:latest make docker-build
```

## 🔋 Batteries Included

* [`proxy-wasm-rust-sdk`](https://github.com/proxy-wasm/proxy-wasm-rust-sdk) WebAssembly for Proxies (Rust SDK).
* `LICENSE-APACHE` and `LICENSE-MIT`: most Rust projects are licensed this way, so these are included for you

## License

Licensed under either of

* Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
* MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.
