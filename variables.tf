variable "ibmcloud_region" {
  description = "Preferred IBM Cloud region to use for your infrastructure"
  default = "us-south"
}
##############################################################################
# VPC Variables
##############################################################################
variable "vpc_name" {
  default = "vpc-demo-3"
  description = "Name of your VPC"
}

variable "zone1" {
  default = "us-south-1"
  description = "Define the 1st zone of the region"
}

variable "zone2" {
  default = "us-south-2"
  description = "Define the 2nd zone of the region"
}

variable "zone3" {
  default = "us-south-3"
  description = "Define the 3nd zone of the region"
}

variable "zone1_cidr" {
  default = "172.17.1.0/24"
  description = "CIDR block to be used for zone 1"
}

variable "zone2_cidr" {
  default = "172.17.2.0/24"
  description = "CIDR block to be used for zone 2"
}

variable "zone3_cidr" {
  default = "172.17.3.0/24"
  description = "CIDR block to be used for zone 3"
}

##############################################################################
# Cluster Variables
##############################################################################

variable "cluster_name" {
  description = "name for the iks cluster"
  default     = "roks-on-vpc-cluter"
}

variable "machine_type" {
  description = "Machine type for the OpenShift Cluster"
  default     = "bx2.4x16"
}

variable "kube_version" {
  default = "4.3.31_openshift"
}

variable "worker_count" {
  description = "Number of workers per zone"
  default     = 1
}

variable "disable_pse" {
  description = "Disable public service endpoint for cluster. True or false"
  default     = false
}

variable "enable_albs" {
  description = "Enable ALBs for cluster"
  default     = true
}

variable "only_private_albs" {
  description = "enable only private albs"
  default     = false
}