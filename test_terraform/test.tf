variable resource { default="n/a" }
variable token {
  description = "OAuth-token, you can get him -> https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

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
  for_each = toset(var.resource.acme_server.hostname)
  name        =  each.value
  platform_id = "standard-v1"
  zone        =  var.resource.acme_server.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
      initialize_params {
        image_id = "fd81lesr11r8ri7p0jjc"
        name        = "disk-root-${each.value}"
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



# output "show_var_resource" {
#   value = var.resource
# }
#
# output "show_var_acme_server" {
#   value = var.resource.acme_server
# }
#
# output "show_var_acme_server_cores" {
#   value = var.resource.acme_server.cores
# }
#
# output "show_var_acme_server_hostname_1" {
#   value = var.resource.acme_server.hostname
# }
#
#
# output "print_the_names" {
#   value = [for name in var.resource.acme_server.hostname : name]
# }
