#### Adding Load Balancer #####

resource "oci_load_balancer_load_balancer" "loadbalancer1" {
	compartment_id = var.compartment_ocid
    display_name = "loadbalancer1"
    shape = "100Mbps"
    subnet_ids = [oci_core_subnet.loadsubnet.id]
}

resource "oci_load_balancer_backend_set" "lb_backendset1" {
	load_balancer_id = oci_load_balancer_load_balancer.loadbalancer1.id
	name = "lb_backendset1"
	policy = "ROUND_ROBIN"
	
	health_checker {
		protocol = "TCP"
		port = "80"
		retries = "3"
		interval_ms = "100000"
		timeout_in_millis = "3000"
	}
}

resource "oci_load_balancer_backend" "lb-backend1" {
	backendset_name = oci_load_balancer_backend_set.lb_backendset1.name
	load_balancer_id = oci_load_balancer_load_balancer.loadbalancer1.id
	ip_address = oci_core_instance.Webserver-AD1.private_ip
	#ip_address = "10.0.1.2"
	port = 80
    	backup = "false"
    	drain = "false"
    	offline = "false"
    	weight = "1"
}

resource "oci_load_balancer_backend" "lb-backend2" {
	backendset_name = oci_load_balancer_backend_set.lb_backendset1.name
	load_balancer_id = oci_load_balancer_load_balancer.loadbalancer1.id
	ip_address = oci_core_instance.Webserver-AD2.private_ip
	#ip_address = "10.0.2.2"
	port = 80
    	backup = "false"
    	drain = "false"
    	offline = "false"
    	weight = "1"

}

resource "oci_load_balancer_listener" "lb_listener"{
	default_backend_set_name = oci_load_balancer_backend_set.lb_backendset1.name
	load_balancer_id = oci_load_balancer_load_balancer.loadbalancer1.id
	name = "lb_listener"
	port = "80"
	protocol = "HTTP"
}

output "lb_public_ip" {
  value = ["${oci_load_balancer_load_balancer.loadbalancer1.ip_address_details}"]
}

