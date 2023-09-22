## APIGW VM lab

## Run server 
`consul agent -config-file server.hcl`

## Run Client 1(running counting app)
```
consul agent -config-file client-count.hcl
consul services register counting.hcl
consul connect envoy -sidecar-for counting -- -l debug
```
// 
Download counting for Mac arm64/amd64 from :
https://github.com/hashicorp/demo-consul-101
//

### Run Counting App:
`PORT=9003 ./counting-service_darwin_arm64`


## Run Client 2(running apigw)
`consul agent -config-file client-api.hcl`

### create a config-file for openssl for Inline cert creation process:
`cat gateway-api-ca-config.cnf`
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
commonName              = counting.consul.local
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
consul config write config-gateway-api.hcl
consul config write config-gateway-api-certificate.hcl

```

### Run envoy as api-gateway:
`consul connect envoy -gateway api -register -service gateway-api -- -l debug`

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
