resource "yandex_logging_group" "logging_group" {
  description      = var.yc_logging_group_name
  folder_id        = var.yc_folder_id
  name             = var.yc_logging_group_name
  retention_period = var.yc_logging_group_retention_period
}

resource "yandex_iam_service_account" "sa_cluster" {
  name        = var.yc_sa_cluster_name
  description = var.yc_sa_cluster_name
  folder_id   = var.yc_folder_id
}

resource "yandex_iam_service_account" "sa_node" {
  name        = var.yc_sa_node_name
  description = var.yc_sa_node_name
  folder_id   = var.yc_folder_id
}

resource "yandex_iam_service_account" "sa_gwin" {
  name        = var.yc_sa_gwin_name
  description = var.yc_sa_gwin_name
  folder_id   = var.yc_folder_id
}


resource "yandex_resourcemanager_folder_iam_member" "sa_cluster_role" {
  for_each = toset([
    "load-balancer.admin",
    "logging.writer",
    "k8s.clusters.agent",
    "vpc.publicAdmin"
  ])
  folder_id = var.yc_folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.sa_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_gwin_role" {
  for_each = toset([
    "alb.editor",
    "vpc.publicAdmin",
    "certificate-manager.certificates.downloader",
    "certificate-manager.editor",
    "compute.viewer",
    "k8s.viewer",
    "smart-web-security.editor",
    "logging.writer",
    "vpc.user"
  ])
  folder_id = var.yc_folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.sa_gwin.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_node_role" {
  for_each = toset([
    "container-registry.images.pusher",
    "container-registry.images.puller"
  ])
  folder_id = var.yc_folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.sa_node.id}"
}

resource "yandex_vpc_network" "net" {
  description = var.yc_net_name
  folder_id   = var.yc_folder_id
  name        = var.yc_net_name
}

resource "yandex_vpc_subnet" "subnet_1" {
  description = var.yc_subnet_1_name
  folder_id   = var.yc_folder_id
  name        = var.yc_subnet_1_name
  network_id  = yandex_vpc_network.net.id
  v4_cidr_blocks = [
    var.yc_subnet_1_v4_cidr_block
  ]
  zone = var.yc_subnet_1_zone
}

resource "yandex_vpc_subnet" "subnet_2" {
  description = var.yc_subnet_2_name
  folder_id   = var.yc_folder_id
  name        = var.yc_subnet_2_name
  network_id  = yandex_vpc_network.net.id
  v4_cidr_blocks = [
    var.yc_subnet_2_v4_cidr_block
  ]
  zone = var.yc_subnet_2_zone
}

resource "yandex_vpc_subnet" "subnet_3" {
  description = var.yc_subnet_3_name
  folder_id   = var.yc_folder_id
  name        = var.yc_subnet_3_name
  network_id  = yandex_vpc_network.net.id
  v4_cidr_blocks = [
    var.yc_subnet_3_v4_cidr_block
  ]
  zone = var.yc_subnet_3_zone
}

resource "yandex_vpc_subnet" "subnet_4" {
  description = var.yc_subnet_4_name
  folder_id   = var.yc_folder_id
  name        = var.yc_subnet_4_name
  network_id  = yandex_vpc_network.net.id
  v4_cidr_blocks = [
    var.yc_subnet_4_v4_cidr_block
  ]
  zone = var.yc_subnet_4_zone
}

resource "yandex_kms_symmetric_key" "kms_key" {
  default_algorithm = var.yc_kms_key_default_algorithm
  description       = var.yc_kms_key_name
  folder_id         = var.yc_folder_id
  name              = var.yc_kms_key_name
}

resource "yandex_kubernetes_cluster" "k8s_cluster" {

  depends_on = [
    yandex_resourcemanager_folder_iam_member.sa_cluster_role,
    yandex_resourcemanager_folder_iam_member.sa_node_role
  ]

  cluster_ipv4_range = var.yc_k8s_cluster_ipv4_range
  description        = var.yc_k8s_cluster_name
  folder_id          = var.yc_folder_id
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_key.id
  }
  master {
    version   = var.yc_k8s_cluster_master_version
    public_ip = var.yc_k8s_cluster_master_public_ip
    zonal {
      zone      = var.yc_k8s_cluster_master_zone ### Переделать
      subnet_id = yandex_vpc_subnet.subnet_1.id  ### Переделать
    }
    master_logging {
      enabled                    = var.yc_k8s_cluster_master_logging_enabled
      log_group_id               = yandex_logging_group.logging_group.id
      kube_apiserver_enabled     = var.yc_k8s_cluster_master_logging_kube_apiserver_enabled
      cluster_autoscaler_enabled = var.yc_k8s_cluster_master_logging_cluster_autoscaler_enabled
      events_enabled             = var.yc_k8s_cluster_master_logging_events_enabled
      audit_enabled              = var.yc_k8s_cluster_master_logging_audit_enabled
    }
    maintenance_policy {
      auto_upgrade = var.yc_k8s_cluster_master_maintenance_policy_auto_upgrade
    }
    scale_policy {
      auto_scale {
        min_resource_preset_id = var.yc_k8s_cluster_master_scale_policy_auto_scale_min_resource_preset_id
      }
    }
  }
  name                     = var.yc_k8s_cluster_name
  network_id               = yandex_vpc_network.net.id
  node_ipv4_cidr_mask_size = var.yc_k8s_cluster_node_ipv4_cidr_mask_size
  node_service_account_id  = yandex_iam_service_account.sa_node.id
  release_channel          = var.yc_k8s_cluster_release_channel
  service_account_id       = yandex_iam_service_account.sa_cluster.id
  service_ipv4_range       = var.yc_k8s_cluster_service_ipv4_range
  workload_identity_federation {
    enabled = var.yc_k8s_cluster_workload_identity_federation_enabled
  }
}

resource "yandex_kubernetes_node_group" "k8s_node_group_1" {
  allocation_policy {
    location {
      zone = var.yc_k8s_node_group_1_zone_1
    }
    location {
      zone = var.yc_k8s_node_group_1_zone_2
    }
    location {
      zone = var.yc_k8s_node_group_1_zone_3
    }
  }
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  deploy_policy {
    max_expansion   = var.yc_k8s_node_group_1_deploy_policy_max_expansion
    max_unavailable = var.yc_k8s_node_group_1_deploy_policy_max_unavailable
  }
  description = var.yc_k8s_node_group_1_name
  instance_template {
    platform_id = var.yc_k8s_node_group_1_instance_template_platform_id
    resources {
      memory        = var.yc_k8s_node_group_1_instance_template_resources_memory
      cores         = var.yc_k8s_node_group_1_instance_template_resources_cores
      core_fraction = var.yc_k8s_node_group_1_instance_template_resources_core_fraction
    }
    boot_disk {
      size = var.yc_k8s_node_group_1_instance_template_boot_disk_size
      type = var.yc_k8s_node_group_1_instance_template_boot_disk_type
    }
    network_interface {
      subnet_ids = [
        yandex_vpc_subnet.subnet_2.id,
        yandex_vpc_subnet.subnet_3.id,
        yandex_vpc_subnet.subnet_4.id
      ]
      nat  = var.yc_k8s_node_group_1_instance_template_network_interface_nat
      ipv4 = var.yc_k8s_node_group_1_instance_template_network_interface_ipv4
    }
    scheduling_policy {
      preemptible = var.yc_k8s_node_group_1_instance_template_scheduling_policy_preemptible
    }
    container_runtime {
      type = var.yc_k8s_node_group_1_instance_template_container_runtime_type
    }
    metadata = {
      ssh-keys = var.yc_k8s_node_group_1_instance_template_metadata_ssh-keys
    }
  }
  maintenance_policy {
    auto_upgrade = var.yc_k8s_node_group_1_maintenance_policy_auto_upgrade
    auto_repair  = var.yc_k8s_node_group_1_maintenance_policy_auto_repair
  }
  name = var.yc_k8s_node_group_1_name
  scale_policy {
    fixed_scale {
      size = var.yc_k8s_node_group_1_scale_policy_fixed_scale_size
    }
  }
  version = var.yc_k8s_node_group_1_version
  workload_identity_federation {
    enabled = var.yc_k8s_node_group_1_workload_identity_federation_enabled
  }
}

resource "yandex_iam_workload_identity_oidc_federation" "wlif" {
  name      = "gwin-federation"
  folder_id = var.yc_folder_id
  issuer    = yandex_kubernetes_cluster.k8s-cluster.workload_identity_federation[0].issuer
  audiences = [yandex_kubernetes_cluster.k8s-cluster.workload_identity_federation[0].issuer]
  jwks_url  = yandex_kubernetes_cluster.k8s-cluster.workload_identity_federation[0].jwks_uri

  depends_on = [yandex_kubernetes_cluster.k8s-cluster]
}

resource "yandex_iam_workload_identity_federated_credential" "gwin_cred" {
  service_account_id  = yandex_iam_service_account.sa_gwin.id
  federation_id       = yandex_iam_workload_identity_oidc_federation.wlif.id
  external_subject_id = "system:serviceaccount:yandex-system:gwin"

  depends_on = [yandex_iam_workload_identity_oidc_federation.wlif]
}

resource "yandex_kubernetes_marketplace_helm_release" "gwin_helm_release" {
  cluster_id      = yandex_kubernetes_cluster.k8s_cluster.id
  product_version = "f2e04077v04sobds7gkt"
  name            = "gwin"
  namespace       = "yandex-system"
  user_values = {
    "controller.folderId"                                                     = var.yc_folder_id
    "controller.ycServiceAccount.workloadIdentityFederation.serviceAccountID" = yandex_iam_service_account.sa_gwin.id
    "controller.defaultBalancerSubnets" = yamlencode([
      yandex_vpc_subnet.subnet_1.id,
      yandex_vpc_subnet.subnet_2.id,
    ])
  }
}