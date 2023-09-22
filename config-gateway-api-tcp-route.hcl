Kind = "tcp-route"
Name = "counting-tcp-route"

Services = [
  {
    Name = "counting"
  }
]

Parents = [
  {
    Kind = "api-gateway"
    Name = "gateway-api"
    SectionName = "api-gw-listener"
  }
]
