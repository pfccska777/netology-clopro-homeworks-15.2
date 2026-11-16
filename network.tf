# Используем существующую сеть из задания 15.1
data "yandex_vpc_network" "netology" {
  network_id = "enpv616q4nvrrgo5brr1"
}

# Используем публичную подсеть из задания 15.1
data "yandex_vpc_subnet" "public" {
  subnet_id = "e9b86hsj0glcmbro4v7f"
}
