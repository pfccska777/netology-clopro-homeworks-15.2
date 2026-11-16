# Сетевой балансировщик нагрузки
resource "yandex_lb_network_load_balancer" "lamp" {
  name      = "netology-lamp-nlb"
  folder_id = "b1g6tqqvhv8rh3iuhp52"

  # Входящие HTTP-запросы
  listener {
    name = "http-listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Подключение Instance Group
  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id

    # Проверка доступности веб-серверов
    healthcheck {
      name                = "http-healthcheck"
      interval            = 10
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2

      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}
