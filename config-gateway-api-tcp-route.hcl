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
    Name = "api-gw"
    SectionName = "api-gw-listener"
  }
]
