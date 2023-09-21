data_dir = "clientdata"
node_name = "counting"
#license_path = "/etc/consul.d/license.hclic"
log_level = "DEBUG"

bind_addr = "127.0.0.2"
client_addr = "127.0.0.2"

retry_join = ["127.0.0.1"]

connect {
  enabled = true
}

ports {
  grpc = 8502
}
