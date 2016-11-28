# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "david.delande@orange.com"
    tenant_name = "0750173703_semere"
    password  = "$218Tps!$218Tps&"
    auth_url  = "https://identity.fr1.cloudwatt.com/v2.0"
}

#network1
resource "openstack_networking_network_v2" "superNet1" {
  name = "superNet1"
  admin_state_up = "true"
}

#subnet1
resource "openstack_networking_subnet_v2" "superSubnet1" {
  name = "superSubnet1"
  network_id = "${openstack_networking_network_v2.superNet1.id}"
  cidr = "192.168.199.0/24"
  ip_version = 4
}

#network2
resource "openstack_networking_network_v2" "superNet2" {
  name = "superNet2"
  admin_state_up = "true"
}

#subnet2
resource "openstack_networking_subnet_v2" "superSubnet2" {
  name = "superSubnet2"
  network_id = "${openstack_networking_network_v2.superNet2.id}"
  cidr = "192.168.200.0/24"
  ip_version = 4
}

#security Group1
resource "openstack_compute_secgroup_v2" "superSecgroup1" {
  name = "superSecgroup1"
  description = "My first Ubuntu 16.04 security group"
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

#security Group2
resource "openstack_compute_secgroup_v2" "superSecgroup2" {
  name = "superSecgroup2"
  description = "My first Ubuntu 16.04 security group"
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

#security Group3
resource "openstack_compute_secgroup_v2" "superSecgroup3" {
  name = "superSecgroup3"
  description = "My second Ubuntu 16.04 security group"
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

#port1
resource "openstack_networking_port_v2" "ubuntuPort1" {
  name = "ubuntuPort1"
  network_id = "${openstack_networking_network_v2.superNet1.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.superSecgroup1.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet1.id}"
  }
}

#port2
resource "openstack_networking_port_v2" "ubuntuPort2" {
  name = "ubuntuPort2"
  network_id = "${openstack_networking_network_v2.superNet2.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.superSecgroup2.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet2.id}"
  }
}

#port3
resource "openstack_networking_port_v2" "ubuntuPort3" {
  name = "ubuntuPort3"
  network_id = "${openstack_networking_network_v2.superNet2.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.superSecgroup3.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet2.id}"
  }
}

#instance1
resource "openstack_compute_instance_v2" "Ubuntu1" {
  name = "Ubuntu 16.04"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"

  network {
    port = "${openstack_networking_port_v2.ubuntuPort1.id}"
  }

  network {
    port = "${openstack_networking_port_v2.ubuntuPort2.id}"
  }
}

#instance2
resource "openstack_compute_instance_v2" "Ubuntu2" {
  name = "Main Ubuntu 16.04"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"
  security_groups = ["${openstack_compute_secgroup_v2.superSecgroup3.name}"]

  network {
    port = "${openstack_networking_port_v2.ubuntuPort3.id}"
  }
}