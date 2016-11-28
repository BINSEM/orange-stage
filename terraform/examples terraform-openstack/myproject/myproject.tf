# Configure provider
provider "openstack" {
    tenant_name = "${var.tenant_name}"
    user_name  = "${var.user_name}"
    password  = "${var.password}"
    auth_url  = "${var.auth_url}"
    insecure = true
}
 
#Network and routing elements

resource "openstack_networking_router_v2" "router_1" {
  name = "router_1"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "myproject_internal_network" {
  name = "myproject_internal_network"
  admin_state_up = "true"
}
 
resource "openstack_networking_subnet_v2" "myproject_internal_subnet" {
  name = "myproject_internal_subnet"
  network_id = "${openstack_networking_network_v2.myproject_internal_network.id}"
  cidr = "${var.myproject_internal_subnet_cidr}"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["${var.dns_name_server_1}","${var.dns_name_server_2}"]
}
 
resource "openstack_networking_router_interface_v2" "myproject_internal_router_interface" {
  region = ""
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.myproject_internal_subnet.id}"
}
 
#Security Group

resource "openstack_compute_secgroup_v2" "myproject_as_secgroup" {
  name = "myproject_as_secgroup"
  description = "myproject_as_secgroup"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}
 
#Instance

resource "openstack_compute_instance_v2" "myproject_as" {
  name = "myproject_as"
  flavor_name = "${var.flavor_name}"
  image_id= "${var.image_id}"
  key_pair = "${var.key_pair}"
  security_groups = ["myproject_as_secgroup"]
  network = {
    name = "myproject_internal_network"
    uuid = "${openstack_networking_network_v2.myproject_internal_network.id}"
  }
  floating_ip = "${var.myproject_as_floating_ip}"
}