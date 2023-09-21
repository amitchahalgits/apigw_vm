server = true
bootstrap = true
# license_path = "/etc/consul.d/license.hclic"
log_level = "DEBUG"

data_dir = "serverdata"

client_addr = "127.0.0.1"
bind_addr = "127.0.0.1"

ui_config {
  enabled=true
}

connect {
  enabled = true
}

ports {
  grpc = 8502
}
