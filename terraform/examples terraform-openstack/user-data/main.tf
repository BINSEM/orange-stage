variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "david.delande@orange.com"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "0750173703_semere"
}

variable "openstack_password" {
    description = "The password for the Tenant."
    default  = "$218Tps!$218Tps&"
}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "https://identity.fr1.cloudwatt.com/v2.0"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "Biniam"
}

#variable "tenant_network" {
#    description = "The network to be used."
#    default  = "Mynet"
#}