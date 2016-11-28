resource "openstack_compute_instance_v2" "web" {
  name = "${format("web-%02d", count.index+1)}"
  image_id = "615d6726-4ca7-44ee-b65c-93c9d8967d22"
  flavor_name = "n1.cw.highcpu-2"
  availability_zone = "nova"
  key_pair = "${openstack_keypair}"
  security_groups = ["default"]
  network {
    name = "private"
  }
  user_data = "${file("bootstrapweb.sh")}"
}