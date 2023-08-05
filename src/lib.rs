use log::debug;
use log::error;
use log::info;
use proxy_wasm::traits::*;
use proxy_wasm::types::*;

proxy_wasm::main! {{
    proxy_wasm::set_log_level(LogLevel::Trace);
    proxy_wasm::set_root_context(|_| -> Box<dyn RootContext> { Box::new(HttpHeadersRoot) });
}}

struct HttpHeadersRoot;

impl Context for HttpHeadersRoot {}

impl RootContext for HttpHeadersRoot {
    fn get_type(&self) -> Option<ContextType> {
        Some(ContextType::HttpContext)
    }

    fn create_http_context(&self, context_id: u32) -> Option<Box<dyn HttpContext>> {
        Some(Box::new(HttpHeaders { context_id }))
    }

    fn on_configure(&mut self, _plugin_configuration_size: usize) -> bool {
        if let Some(config_bytes) = self.get_plugin_configuration() {
            if let Ok(config_str) = std::str::from_utf8(&config_bytes) {
                debug!("#{} -> {}", "on_configure", config_str);
            } else {
                error!("Failed to convert configuration bytes to string");
                return false;
            }
        }
        true
    }

}

struct HttpHeaders {
    context_id: u32,
}

impl Context for HttpHeaders {}

impl HttpContext for HttpHeaders {
    fn on_http_request_headers(&mut self, _: usize, _: bool) -> Action {
        if let Some(path) = self.get_http_request_header(":path")  {
            if path.starts_with("/v2") {
                self.send_http_response(
                    401,
                    vec![("WWW-Authenticate", "Basic realm=\"Registry Realm\""),("Docker-Distribution-Api-Version","registry/2.0"),("Content-Type","application/json; charset=utf-8")],
                    Some("Unauthorized".as_bytes()),
                );
                return Action::Pause;
            }
        }
        return Action::Continue;
    }

    fn on_http_response_headers(&mut self, _: usize, _: bool) -> Action {
        for (name, value) in &self.get_http_response_headers() {
            info!("#{} <- {}: {}", self.context_id, name, value);
        }
        Action::Continue
    }

    fn on_log(&mut self) {
        info!("#{} completed using -> {} by {}.", self.context_id,"istio-wasm","registry");
    }
}
