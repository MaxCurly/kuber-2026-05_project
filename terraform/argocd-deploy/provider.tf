terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.226.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket                      = "kuber-2026-05-project-s3-tfstate"
    region                      = "ru-central1"
    key                         = "argocd-deploy_terraform.tfstate"
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

provider "kubernetes" {
  host                   = data.yandex_kubernetes_cluster.k8s-cluster.master[0].external_v4_endpoint
  cluster_ca_certificate = data.yandex_kubernetes_cluster.k8s-cluster.master[0].cluster_ca_certificate
  token                  = data.yandex_client_config.client.iam_token
}

provider "helm" {
  kubernetes = {
    host                   = data.yandex_kubernetes_cluster.k8s-cluster.master[0].external_v4_endpoint
    cluster_ca_certificate = data.yandex_kubernetes_cluster.k8s-cluster.master[0].cluster_ca_certificate
    token                  = data.yandex_client_config.client.iam_token
  }
}

provider "kubectl" {
  host                   = data.yandex_kubernetes_cluster.k8s-cluster.master[0].external_v4_endpoint
  cluster_ca_certificate = data.yandex_kubernetes_cluster.k8s-cluster.master[0].cluster_ca_certificate
  token                  = data.yandex_client_config.client.iam_token
  load_config_file       = false
}

data "yandex_kubernetes_cluster" "k8s-cluster" {
  name = var.yc_k8s_cluster_name
}

data "yandex_client_config" "client" {}