data_dir = "clientdata-api"
node_name = "apigw"
#license_path = "/etc/consul.d/license.hclic"
log_level = "DEBUG"

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

retry_join = ["192.168.64.1"]

connect {
  enabled = true
}

ports {
  grpc = 8502
}
