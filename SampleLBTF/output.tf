# Output the vcn information
output "show-vcn1-id" {
  value = "${data.oci_core_vcn.vcn1.id}"
  description = "VCN ID"
}
# Output the vcn information
output "show-vcn1-domain" {
        value = "${data.oci_core_vcn.vcn1.vcn_domain_name}"
        description = "This is VCN domain name"
}
# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}
# Output public IP of web server AD1

output "Webserver-AD1-IP"{
	value = ["${data.oci_core_instance.Webserver-AD1.public_ip}"]
	description = "WebServer-AD1 Public IP"
} 

# Output public IP of web server AD2

output "Webserver-AD2-IP"{
	value = ["${data.oci_core_instance.Webserver-AD2.public_ip}"]
        description = "WebServer-AD2 Public IP"
} 
# Output private IP of web server AD1

output "Webserver-AD1-Private_IP"{
        value = ["${data.oci_core_instance.Webserver-AD1.private_ip}"]
        description = "WebServer-AD1 Private IP"
}

# Output private IP of web server AD1

output "Webserver-AD2-Private_IP"{
        value = ["${data.oci_core_instance.Webserver-AD2.private_ip}"]
        description = "WebServer-AD2 Private IP"
}

/*output "LoadBalancer-Public-IP"{
	value = ["${data.oci_load_balancer_load_balancers.test_load_balancers.ip_address_details}"]
	description = "Load Balancer Public IP"
}*/
