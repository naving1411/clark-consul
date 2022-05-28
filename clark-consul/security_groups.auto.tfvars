service_consul_service = {
  name = "Service-Monitoring"
  description =  "Monitoring security group"
  rules = [
    {
      from_port = 8300
      to_port   = 8300
      ip = ["10.30.1.0/24"]
      description = "Used by clients to talk to server"
    },
    {
      from_port = 8301
      to_port   = 8301
      ip = ["10.30.1.0/24"]
      description = "Used to gossip with server"
    },
    {
      from_port = 443
      to_port   = 443
      ip = ["10.30.1.0/24"]
      description = "TLS encryption"
    }
  ]
}