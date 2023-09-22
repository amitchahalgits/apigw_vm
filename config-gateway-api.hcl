Kind = "api-gateway"
Name = "gateway-api"

Listeners = [
    {
        Port = 8443
        Name = "api-gw-listener"
        Protocol = "tcp"
        TLS = {
            Certificates = [
                {
                    Kind = "inline-certificate"
                    Name = "api-gw-certificate"
                }
            ]
        }
    }
]
