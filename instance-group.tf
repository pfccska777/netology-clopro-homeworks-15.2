# Группа виртуальных машин LAMP
resource "yandex_compute_instance_group" "lamp" {
  name               = "netology-lamp-ig"
  folder_id          = "b1g6tqqvhv8rh3iuhp52"
  service_account_id = yandex_iam_service_account.ig_sa.id

  # Шаблон виртуальной машины
  instance_template {
    name        = "netology-lamp-{instance.index}"
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"

      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 20
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id         = data.yandex_vpc_network.netology.id
      subnet_ids         = [data.yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.lamp_sg.id]
      nat                = false
    }

    metadata = {
      "user-data" = templatefile("${path.module}/cloud-init.yaml.tftpl", {
        ssh_public_key = trimspace(file(pathexpand("~/.ssh/netology_15_1.pub")))
        image_url      = "https://storage.yandexcloud.net/pfccska777-netology-15-2-20261116/image.jpg"
      })
    }
  }

  # Фиксированное количество машин
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  # Зона доступности
  allocation_policy {
    zones = ["ru-central1-a"]
  }

  # Политика развёртывания
  deploy_policy {
    max_unavailable = 1
    max_creating    = 3
    max_expansion   = 0
    max_deleting    = 1
  }

  # Проверка работоспособности Apache
  health_check {
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3

    http_options {
      port = 80
      path = "/index.html"
    }
  }

  # Целевая группа для Network Load Balancer
  load_balancer {
    target_group_name = "netology-lamp-targets"
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.compute_editor,
    yandex_resourcemanager_folder_iam_member.lb_editor
  ]
}
