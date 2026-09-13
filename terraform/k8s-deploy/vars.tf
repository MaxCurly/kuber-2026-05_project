variable "yc_folder_id" {
  type    = string
  default = null
}

variable "yc_default_zone" {
  type    = string
  default = null
}

variable "yc_logging_group_name" {
  type    = string
  default = null
}

variable "yc_logging_group_retention_period" {
  type    = string
  default = null
}

variable "yc_sa_cluster_name" {
  type    = string
  default = null
}

variable "yc_sa_node_name" {
  type    = string
  default = null
}

variable "yc_net_name" {
  type    = string
  default = null
}

variable "yc_subnet_1_name" {
  type    = string
  default = null
}

variable "yc_subnet_1_v4_cidr_block" {
  type    = string
  default = null
}

variable "yc_subnet_1_zone" {
  type    = string
  default = null
}

variable "yc_subnet_2_name" {
  type    = string
  default = null
}

variable "yc_subnet_2_v4_cidr_block" {
  type    = string
  default = null
}

variable "yc_subnet_2_zone" {
  type    = string
  default = null
}

variable "yc_subnet_3_name" {
  type    = string
  default = null
}

variable "yc_subnet_3_v4_cidr_block" {
  type    = string
  default = null
}

variable "yc_subnet_3_zone" {
  type    = string
  default = null
}

variable "yc_subnet_4_name" {
  type    = string
  default = null
}

variable "yc_subnet_4_v4_cidr_block" {
  type    = string
  default = null
}

variable "yc_subnet_4_zone" {
  type    = string
  default = null
}

variable "yc_kms_key_default_algorithm" {
  type    = string
  default = null
}

variable "yc_kms_key_name" {
  type    = string
  default = null
}

variable "yc_k8s_cluster_ipv4_range" {
  type    = string
  default = "10.112.0.0/16"
}

variable "yc_k8s_cluster_name" {
  type    = string
  default = null
}

variable "yc_k8s_cluster_master_version" {
  type    = string
  default = null
}

variable "yc_k8s_cluster_master_public_ip" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_zone" {
  type    = string
  default = null
}

variable "yc_k8s_cluster_master_logging_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_logging_kube_apiserver_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_logging_cluster_autoscaler_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_logging_events_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_logging_audit_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_maintenance_policy_auto_upgrade" {
  type    = bool
  default = false
}

variable "yc_k8s_cluster_master_scale_policy_auto_scale_min_resource_preset_id" {
  type    = string
  default = null
}

variable "yc_k8s_cluster_node_ipv4_cidr_mask_size" {
  type    = number
  default = 24
}

variable "yc_k8s_cluster_release_channel" {
  type    = string
  default = "STABLE"
}

variable "yc_k8s_cluster_service_ipv4_range" {
  type    = string
  default = "10.96.0.0/16"
}

variable "yc_k8s_cluster_workload_identity_federation_enabled" {
  type    = bool
  default = false
}

variable "yc_k8s_node_group_1_zone_1" {
  type    = string
  default = null
}

variable "yc_k8s_node_group_1_zone_2" {
  type    = string
  default = null
}

variable "yc_k8s_node_group_1_zone_3" {
  type    = string
  default = null
}

variable "yc_k8s_node_group_1_deploy_policy_max_expansion" {
  type    = number
  default = 1
}

variable "yc_k8s_node_group_1_deploy_policy_max_unavailable" {
  type    = number
  default = 2
}

variable "yc_k8s_node_group_1_name" {
  type    = string
  default = null
}

variable "yc_k8s_node_group_1_instance_template_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "yc_k8s_node_group_1_instance_template_resources_memory" {
  type    = number
  default = 2
}

variable "yc_k8s_node_group_1_instance_template_resources_cores" {
  type    = number
  default = 2
}

variable "yc_k8s_node_group_1_instance_template_resources_core_fraction" {
  type    = number
  default = 20
}

variable "yc_k8s_node_group_1_instance_template_boot_disk_size" {
  type    = number
  default = 64
}

variable "yc_k8s_node_group_1_instance_template_boot_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "yc_k8s_node_group_1_instance_template_network_interface_nat" {
  type    = bool
  default = true
}

variable "yc_k8s_node_group_1_instance_template_network_interface_ipv4" {
  type    = bool
  default = true
}

variable "yc_k8s_node_group_1_instance_template_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "yc_k8s_node_group_1_instance_template_container_runtime_type" {
  type    = string
  default = "containerd"
}

variable "yc_k8s_node_group_1_instance_template_metadata_ssh-keys" {
  type    = string
  default = null
}

variable "yc_k8s_node_group_1_maintenance_policy_auto_upgrade" {
  type    = bool
  default = false
}

variable "yc_k8s_node_group_1_maintenance_policy_auto_repair" {
  type    = bool
  default = true
}

variable "yc_k8s_node_group_1_scale_policy_fixed_scale_size" {
  type    = number
  default = 1
}

variable "yc_k8s_node_group_1_version" {
  type    = string
  default = "1.35"
}

variable "yc_k8s_node_group_1_workload_identity_federation_enabled" {
  type    = bool
  default = false
}
