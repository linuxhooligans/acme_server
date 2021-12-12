terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  token     =  var.token
  cloud_id  =  var.resource.acme_server.cloud_id
  folder_id =  var.resource.acme_server.folder_id
  zone      =  var.resource.acme_server.zone
}

resource "yandex_compute_instance" "default" {
  name        =  "test"
  platform_id = "standard-v1"
  zone        =  var.resource.acme_server.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
      initialize_params {
        image_id = "fd81lesr11r8ri7p0jjc"
        name        = "disk-root"
        description = "Disk for the root"
        size = 20
      }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "foo" {
  name = "lab-network-acme"
}

resource "yandex_vpc_subnet" "foo" {
  v4_cidr_blocks = var.resource.acme_server.v4_cidr_blocks
  zone       =  var.resource.acme_server.zone
  network_id = "${yandex_vpc_network.foo.id}"
}
