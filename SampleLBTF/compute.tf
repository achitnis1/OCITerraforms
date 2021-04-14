/* Instances */
resource "oci_core_instance" "Webserver-AD1" {
	 availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")
	 compartment_id = var.compartment_ocid
	 shape = var.instance_shape
	 display_name = "Webserver-AD1"
	 
	  create_vnic_details {
		subnet_id = oci_core_subnet.subnet1.id
		display_name = "primaryvnic"
		assign_public_ip = true
     		hostname_label = "webserver1"
	  }

	  source_details {
		source_id = "ocid1.image.oc1.iad.aaaaaaaawtb4qxiwri5z2qjeey4zpzqpv2rtxhddzpbvojw2e2c2jevmthva"
		source_type = "image"
	  }
	  
	  metadata = {
		ssh_authorized_keys = var.ssh_public_key
 		user_data = "${base64encode(file("./userdata/bootstrap"))}"
	  }

	  timeouts {
		create = "60m"
	  }

}

resource "oci_core_instance" "Webserver-AD2" {
         availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")
         compartment_id = var.compartment_ocid
         shape = var.instance_shape
         display_name = "Webserver-AD2"

          create_vnic_details {
                subnet_id = oci_core_subnet.subnet2.id
                display_name = "primaryvnic"
                assign_public_ip = true
		hostname_label = "webserver2"
         }

          source_details {
                source_id = "ocid1.image.oc1.iad.aaaaaaaawtb4qxiwri5z2qjeey4zpzqpv2rtxhddzpbvojw2e2c2jevmthva"
                source_type = "image"
          }

          metadata = {
                ssh_authorized_keys = var.ssh_public_key
                user_data = "${base64encode(file("./userdata/bootstrap"))}"
          }

          timeouts {
                create = "60m"
          }

}

data "oci_core_instance" "Webserver-AD1"{
	instance_id = "${oci_core_instance.Webserver-AD1.id}"
}

data "oci_core_instance" "Webserver-AD2"{
	instance_id = "${oci_core_instance.Webserver-AD2.id}"
}
