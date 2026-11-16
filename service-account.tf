# Сервисный аккаунт для Instance Group
resource "yandex_iam_service_account" "ig_sa" {
  name        = "netology-ig-sa"
  description = "Service account for Netology 15.2 Instance Group"
  folder_id   = "b1g6tqqvhv8rh3iuhp52"
}

# Права на управление виртуальными машинами
resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
  folder_id = "b1g6tqqvhv8rh3iuhp52"
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}

# Права на управление сетевым балансировщиком
resource "yandex_resourcemanager_folder_iam_member" "lb_editor" {
  folder_id = "b1g6tqqvhv8rh3iuhp52"
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}
