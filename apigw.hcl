data_dir = "apigwdata"
node_name = "apigw"
#license_path = "/etc/consul.d/license.hclic"
log_level = "DEBUG"

bind_addr = "127.0.0.3"
client_addr = "127.0.0.3"

retry_join = ["127.0.0.1"]

connect {
  enabled = true
}

ports {
  grpc = 8502
}
