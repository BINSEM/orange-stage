# Credentials variables
variable "tenant_name" {}
variable "user_name" {}
variable "password" {}
variable "auth_url" {}
 
# Network variables
variable "myproject_router_id" {}
variable "myproject_internal_subnet_cidr" {}
variable "dns_name_server_1" {}
variable "dns_name_server_2" {}
 
# Instance variables
variable "image_id" {}
variable "flavor_name" {}
variable "key_pair" {}
variable "myproject_as_floating_ip" {}