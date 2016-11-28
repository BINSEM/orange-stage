# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "david.delande@orange.com"
    tenant_name = "0750173703_semere"
    password  = "$218Tps!$218Tps&"
    auth_url  = "https://identity.fr1.cloudwatt.com/v2.0"
}

resource "openstack_blockstorage_volume_v1" "MyVol" {
  name = "MyVol"
  size = 1
}

resource "openstack_compute_instance_v2" "volume-attached" {
  name = "volume-attached"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  key_pair = "Biniam"
  security_groups = ["default"]

  network {
    name = "private"
  }

  volume {
    volume_id = "${openstack_blockstorage_volume_v1.MyVol.id}"
  }
}
