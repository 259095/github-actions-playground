### vpc

variable "cidr" {
    default = "10.0.0.0/16"
}
variable "enable_vpn_gateway" {
    default = false
}
variable "enable_nat_gateway" {
    default = true
}
variable "single_nat_gateway" {
    default = true
}
variable "enable_dns_hostnames" {
    default = true
}
variable "name" {
    default = "iac-revenite"
}