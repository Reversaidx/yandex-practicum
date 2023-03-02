terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  service_account_key_file = "./authorized_key.json"
  cloud_id                 = "b1gj6jkjv626brgi4d0b"
  folder_id                = "b1g9e00mq7kcpk5esq4g"
  zone                     = "ru-central1-a"
}
