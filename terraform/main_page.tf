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
resource "openstack_networking_secgroup_v2" "superSecgroup1" {
  name = "superSecgroup1"
  description = "First port security group"
}

resource "openstack_networking_secgroup_rule_v2" "superSecgroup1_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup1.id}"
}
resource "openstack_networking_secgroup_rule_v2" "superSecgroup1_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup1.id}"
}

#security Group2
resource "openstack_networking_secgroup_v2" "superSecgroup2" {
  name = "superSecgroup2"
  description = "Second port security group"
}

resource "openstack_networking_secgroup_rule_v2" "superSecgroup2_rule_1" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup2.id}"
}
resource "openstack_networking_secgroup_rule_v2" "superSecgroup2_rule_2" {
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup2.id}"
}

#security Group3
resource "openstack_networking_secgroup_v2" "superSecgroup3" {
  name = "superSecgroup3"
  description = "Third port security group"
}

resource "openstack_networking_secgroup_rule_v2" "superSecgroup3_rule_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup3.id}"
}
resource "openstack_networking_secgroup_rule_v2" "superSecgroup3_rule_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.superSecgroup3.id}"
}

#port1
resource "openstack_networking_port_v2" "ubuntuPort1" {
  name = "ubuntuPort1"
  network_id = "${openstack_networking_network_v2.superNet1.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_networking_secgroup_v2.superSecgroup1.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet1.id}"
  }
}

#port2
resource "openstack_networking_port_v2" "ubuntuPort2" {
  name = "ubuntuPort2"
  network_id = "${openstack_networking_network_v2.superNet2.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_networking_secgroup_v2.superSecgroup2.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet2.id}"
  }
}

#port3
resource "openstack_networking_port_v2" "ubuntuPort3" {
  name = "ubuntuPort3"
  network_id = "${openstack_networking_network_v2.superNet2.id}"
  admin_state_up = "true"
  security_group_ids = ["${openstack_networking_secgroup_v2.superSecgroup3.id}"]

  fixed_ip {
    "subnet_id" = "${openstack_networking_subnet_v2.superSubnet2.id}"
  }
}

#instance1
resource "openstack_compute_instance_v2" "Ubuntu1" {
  name = "Ubuntu 16.04"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "BiniamKey1"

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
  key_pair = "BiniamKey2"
  security_groups = ["${openstack_networking_secgroup_v2.superSecgroup3.name}"]

  network {
    port = "${openstack_networking_port_v2.ubuntuPort3.id}"
  }
}