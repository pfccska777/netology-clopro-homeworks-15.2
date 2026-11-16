# Группа безопасности для LAMP-серверов
resource "yandex_vpc_security_group" "lamp_sg" {
  name        = "netology-lamp-sg"
  description = "Security group for LAMP Instance Group"
  network_id  = data.yandex_vpc_network.netology.id

  # HTTP-доступ к веб-серверам
  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  # Проверки состояния от Network Load Balancer
  ingress {
    protocol          = "TCP"
    description       = "Load balancer health checks"
    predefined_target = "loadbalancer_healthchecks"
    port              = 80
  }

  # SSH из публичной ВМ задания 15.1
  ingress {
    protocol       = "TCP"
    description    = "SSH from public VM"
    v4_cidr_blocks = ["192.168.10.34/32"]
    port           = 22
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Allow outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
