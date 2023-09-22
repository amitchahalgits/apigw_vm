server = true
bootstrap = true
# license_path = "/etc/consul.d/license.hclic"
log_level = "DEBUG"

data_dir = "serverdata"

client_addr = "0.0.0.0"
bind_addr = "192.168.64.1"

ui_config {
  enabled=true
}

connect {
  enabled = true
}

ports {
  grpc = 8502
}
