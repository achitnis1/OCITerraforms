#### VCN  #######

resource "oci_core_vcn" "vcn1" {
        cidr_block      = var.vcn_cidr_block
        dns_label       = "tfVCN"
        compartment_id  = var.compartment_ocid
        display_name    = "terraformVCN"
		
 provisioner "local-exec" {
    command = "sleep 5"
  }
}

# Get information about newly created VCN

data "oci_core_vcn" "vcn1" {
    #Required
    vcn_id = "${oci_core_vcn.vcn1.id}"
}
### Create Internet Gateway #####

resource "oci_core_internet_gateway" "IGW" {
        vcn_id = oci_core_vcn.vcn1.id
        compartment_id = var.compartment_ocid
        display_name   = "IGW"
}

#### Route Table #####

resource "oci_core_route_table" "publicRoute" {
	compartment_id = var.compartment_ocid
        vcn_id = oci_core_vcn.vcn1.id
	display_name = "PublicRoute"
	
	route_rules {
		destination = "0.0.0.0/0"
		network_entity_id = oci_core_internet_gateway.IGW.id
		destination_type = "CIDR_BLOCK"
		description = "Route out to outside world"
	}

}
##### Security Lists ######

resource "oci_core_security_list" "slWeb" {
	compartment_id = var.compartment_ocid
        vcn_id = oci_core_vcn.vcn1.id
	display_name = "PublicSecurityList"
	
	egress_security_rules {
		destination = "0.0.0.0/0"
		protocol = "all"
		description = "Allow all traffic"
		stateless = false
	}
	
	ingress_security_rules {
		source = "0.0.0.0/0"
		protocol = "6"
		description = "http traffic on port 80"
		stateless = false
		tcp_options {
   			min = "80"
			max = "80"
		}
	}
	
	ingress_security_rules {
		source = "0.0.0.0/0"
		protocol = "6"
		description = "SSH traffic on port 22"
		stateless = false
		tcp_options {
			min = "22"
			max = "22"
		}
	}

	ingress_security_rules {
		source = "0.0.0.0/0"
		protocol = "6"
		description = "https traffic on port 443"
		stateless = false
		tcp_options {
		min = "443"
		max = "443"
		}
	}

	ingress_security_rules {	
		source = "0.0.0.0/0"
		protocol = "1"
		description = "Ping traffic"
		stateless = false
		icmp_options {
			type = "3"
			code = "4"
		}
		
	}
	
	ingress_security_rules {	
		source = "0.0.0.0/0"
		protocol = "1"
		description = "Ping traffic"
		stateless = false
		icmp_options {
			type = "0"
		}
		
	}
	ingress_security_rules {	
		source = "0.0.0.0/0"
		protocol = "1"
		description = "Ping traffic"
		stateless = false
		icmp_options {
			type = "8"
		}
		
	}

	
}
#### Subnet  #######

resource "oci_core_subnet" "subnet1" {
	cidr_block = var.subnet_cidr_public1
	compartment_id = var.compartment_ocid
	vcn_id = oci_core_vcn.vcn1.id
	availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")
	display_name ="subnet1-AD1"
	dns_label ="web1"
	security_list_ids = [oci_core_security_list.slWeb.id]
	route_table_id = oci_core_route_table.publicRoute.id
	dhcp_options_id     = oci_core_vcn.vcn1.default_dhcp_options_id
}
resource "oci_core_subnet" "subnet2" {
        cidr_block = var.subnet_cidr_public2
        compartment_id = var.compartment_ocid
        vcn_id = oci_core_vcn.vcn1.id
        availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")
        display_name ="subnet2-AD2"
	dns_label ="web2"
        security_list_ids = [oci_core_security_list.slWeb.id]
        route_table_id = oci_core_route_table.publicRoute.id
        dhcp_options_id     = oci_core_vcn.vcn1.default_dhcp_options_id
}
resource "oci_core_subnet" "loadsubnet" {
        cidr_block = var.subnet_cidr_public3
        compartment_id = var.compartment_ocid
        vcn_id = oci_core_vcn.vcn1.id
        display_name ="subnet-loadbalancer"
	dns_label ="load1"
        security_list_ids = [oci_core_security_list.slWeb.id]
        route_table_id = oci_core_route_table.publicRoute.id
        dhcp_options_id     = oci_core_vcn.vcn1.default_dhcp_options_id
}
