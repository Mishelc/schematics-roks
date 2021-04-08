# Create VPC
resource "ibm_is_vpc" "vpc" {
  name = "${var.vpc_name}"
}
# VPC Zones
resource "ibm_is_vpc_address_prefix" "vpc-ap1" {
  name = "vpc-ap1"
  zone = "${var.zone1}"
  vpc  = "${ibm_is_vpc.vpc.id}"
  cidr = "${var.zone1_cidr}"
}

resource "ibm_is_vpc_address_prefix" "vpc-ap2" {
  name = "vpc-ap2"
  zone = "${var.zone2}"
  vpc  = "${ibm_is_vpc.vpc.id}"
  cidr = "${var.zone2_cidr}"
}

# Public Gateways

resource "ibm_is_public_gateway" "gateway1" {
    name = "gateway1"
    vpc = "${ibm_is_vpc.vpc.id}"
    zone = "${var.zone1}"
}

resource "ibm_is_public_gateway" "gateway2" {
    name = "gateway2"
    vpc = "${ibm_is_vpc.vpc.id}"
    zone = "${var.zone2}"
}

# Subnets 
resource "ibm_is_subnet" "node1" {
  name            = "${var.zone1_subnet}"
  vpc             = "${ibm_is_vpc.vpc.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.zone1_cidr}"
  depends_on      = ["ibm_is_vpc_address_prefix.vpc-ap1"]
  public_gateway  = "${ibm_is_public_gateway.gateway1.id}"
}

resource "ibm_is_subnet" "node2" {
  name            = "${var.zone2_subnet}"
  vpc             = "${ibm_is_vpc.vpc.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.zone2_cidr}"
  depends_on      = ["ibm_is_vpc_address_prefix.vpc-ap2"]
  public_gateway  = "${ibm_is_public_gateway.gateway2.id}"
}



# Security Group Rules

resource "ibm_is_security_group_rule" "sg1_tcp_rule" {
  # depends_on = ["ibm_is_floating_ip.floatingip1", "ibm_is_floating_ip.floatingip2"]
  group     = "${ibm_is_vpc.vpc.default_security_group}"
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp = {
    port_min = "30000"
    port_max = "32767"
  }
}

resource "ibm_is_security_group_rule" "sg1_tcp_rule_80" {
  # depends_on = ["ibm_is_floating_ip.floatingip1", "ibm_is_floating_ip.floatingip2"]
  group     = "${ibm_is_vpc.vpc.default_security_group}"
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp = {
    port_min = "80"
    port_max = "80"
  }
}

##############################################################################
# Create Object Storage
##############################################################################
resource "ibm_resource_instance" "cos_instance" {
  name     = "cos_roks_instance"
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}

##############################################################################
# Create ROKS on VPC Cluster
##############################################################################


resource "ibm_container_vpc_cluster" "cluster-roks" {
  depends_on         = ["ibm_is_subnet.node1", "ibm_is_subnet.node2", "ibm_is_subnet.node3"]
  name               = "${var.cluster_name}"
  vpc_id             = "${ibm_is_vpc.vpc.id}"
  kube_version       = "${var.kube_version}"
  flavor             = "${var.machine_type}"
  worker_count       = "${var.worker_count}"
  cos_instance_crn   = "${ibm_resource_instance.cos_instance.id}"
  # resource_group_id  = "${data.ibm_resource_group.resource_group.id}"
  zones = [
    {
      subnet_id = "${ibm_is_subnet.node1.id}"
      name      = "${var.zone1}"
    },
    {
      subnet_id = "${ibm_is_subnet.node2.id}"
      name      = "${var.zone2}"
    }
  ]
  disable_public_service_endpoint = "${var.disable_pse}"
}


