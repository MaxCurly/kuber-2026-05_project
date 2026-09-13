terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.226.0"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket                      = "kuber-2026-05-project-s3-tfstate"
    region                      = "ru-central1"
    key                         = "k8s-deploy_terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

provider "yandex" {
  folder_id = var.yc_folder_id
  zone      = var.yc_default_zone
}