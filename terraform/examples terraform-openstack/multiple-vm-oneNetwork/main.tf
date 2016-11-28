# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "david.delande@orange.com"
    tenant_name = "0750173703_semere"
    password  = "$218Tps!$218Tps&"
    auth_url  = "https://identity.fr1.cloudwatt.com/v2.0"
}

resource "openstack_networking_network_v2" "network_1" {
  name = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name = "secgroup_1"
  description = "a security group"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_networking_port_v2" "port_1" {
  name = "port_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "192.168.199.10"
  }
}

resource "openstack_networking_port_v2" "port_2" {
  name = "port_2"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "192.168.199.11"
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  name = "instance_1"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_1.id}"
  }
}

resource "openstack_compute_instance_v2" "instance_2" {
  name = "instance_2"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_2.id}"
  }
}