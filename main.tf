data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

resource "yandex_vpc_security_group" "basic" {
  name        = "Allow my IP"
  description = "description for my security group"
  network_id  = yandex_vpc_network.default.id


  ingress {
    protocol       = "ANY"
    description    = "rule1 description"
    v4_cidr_blocks = ["${data.http.ip.response_body}/32"]
  }

  egress {
    protocol       = "ANY"
    description    = "Rule description 2"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "yandex_compute_instance" "default" {
  name        = "dev"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 16
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab-subnet-a.id
    ipv4 = true
    nat = true
    nat_ip_address = "51.250.70.232"
    security_group_ids = [yandex_vpc_security_group.basic.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}