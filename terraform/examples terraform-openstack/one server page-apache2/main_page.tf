# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "david.delande@orange.com"
    tenant_name = "0750173703_semere"
    password  = "$218Tps!$218Tps&"
    auth_url  = "https://identity.fr1.cloudwatt.com/v2.0"
}

#network
resource "openstack_networking_network_v2" "superNet" {
  name = "superNet"
  admin_state_up = "true"
}

#subnet
resource "openstack_networking_subnet_v2" "superSubnet" {
  name = "superSubnet"
  network_id = "${openstack_networking_network_v2.superNet.id}"
  cidr = "192.168.199.0/24"
  ip_version = 4
}

#security Group
resource "openstack_compute_secgroup_v2" "superSecgroup" {
  name = "superSecgroup"
  description = "My Ubuntu 16.04 security group"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

#port
resource "openstack_networking_port_v2" "ubuntuPort" {
  name = "ubuntuPort"
  network_id = "${openstack_networking_network_v2.superNet.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.superSecgroup.id}"]
}

#instance
resource "openstack_compute_instance_v2" "Ubuntu" {
  name = "Ubuntu 16.04"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"
  security_groups = ["${openstack_compute_secgroup_v2.superSecgroup.name}"]

  network {
    port = "${openstack_networking_port_v2.ubuntuPort.id}"
  }
}