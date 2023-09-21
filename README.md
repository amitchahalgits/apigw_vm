## Mac Loopback lab
Create multiple Loopbacks:
```
sudo ifconfig lo0 alias 127.0.0.2
sudo ifconfig lo0 alias 127.0.0.3
sudo ifconfig lo0 alias 127.0.0.4
```


### Run server 
`consul agent -config-file server.hcl`

### Run Client(running counting app)
```
consul agent -config-file client.hcl
consul services register counting.hcl
consul connect envoy -sidecar-for counting -- -l debug
```
// 
Download counting for Mac arm64/amd64 from :
https://github.com/hashicorp/demo-consul-101
//

`PORT=9003 ./counting-service_darwin_arm64`

### Run Client(running apigw)
`consul agent -config-file apigw.hcl`

### create a config-file for openssl for Inline cert creation process:
```
[req]
default_bit = 4096
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = San Francisco
organizationName        = HashiCorp
commonName              = counting.hashicorp.com
```

### Generate private key:
`openssl genrsa -out gateway-api-cert.key 4096 2>/dev/null`

### Create CSR:
```
openssl req -new \
  -key gateway-api-cert.key \
  -out gateway-api-cert.csr \
  -config gateway-api-ca-config.cnf 2>/dev/null
```

### Sign CSR and save it :
```
openssl x509 -req -days 3650 \
  -in gateway-api-cert.csr \
  -signkey gateway-api-cert.key \
  -out gateway-api-cert.crt 2>/dev/null

export API_GW_KEY=`cat gateway-api-cert.key`; \
export API_GW_CERT=`cat gateway-api-cert.crt`
```

### Create the `inline-certificate` config entry:
```
Kind = "inline-certificate"
Name = "api-gw-certificate"

Certificate = <<EOT
${API_GW_CERT}
EOT

PrivateKey = <<EOT
${API_GW_KEY}
EOT
EOF
```

### Write the apigw and inline-certificate config entries:
```
consul config write api-config-entry.hcl
consul config write config-gateway-api-certificate.hcl
```

### Run envoy as api-gateway:
`consul connect envoy -gateway api -register -service api-gw`

### Apply TCP route
`consul config write config-gateway-api-tcp-route.hcl`

### Apply Intentions:
```
Kind = "service-intentions"
Name = "counting"
Sources = [
  {
    Name   = "api-gw"
    Action = "allow"
  }
]
```

`consul config write intention-counting.hcl `

### Access App from API gateway : (Need to validate this ??)
`curl 127.0.0.3:8443`
