FROM rust:1.71 as builder
WORKDIR /app
COPY . .
RUN make build

FROM scratch
COPY --from=builder /app/plugin.wasm ./
