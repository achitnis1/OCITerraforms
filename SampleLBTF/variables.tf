variable "tenancy_ocid" {}
variable "region" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

provider "oci" {
        tenancy_ocid = var.tenancy_ocid
        region = var.region
        user_ocid = var.user_ocid
        fingerprint = var.fingerprint
        private_key_path = var.private_key_path
		#compartment_id = var.compartment_ocid
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

#### Network Varaible #####

variable "vcn_cidr_block" {
	default = "10.0.0.0/16"
}

variable "dns_label_vcn" {
	default = "terraformVCN"
}

variable "subnet_cidr_public1"{
	default = "10.0.1.0/24"
}

variable "subnet_cidr_public2"{
	default = "10.0.2.0/24"
}

variable "subnet_cidr_public3"{
	default = "10.0.3.0/24"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}
