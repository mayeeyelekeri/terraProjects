# Get ALB dns name of info-server and update application.properties 
resource "null_resource" "update_server_dns" {
  triggers = {
    always_run = "${timestamp()}"
  }

    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
info_server_ipaddress=${module.alb.alb_server} \
info_server_port=${var.info_server_port} \
src_file=${var.src_properties_file_client} \
dest_file=${var.dest_properties_file_client}" \
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner

    #depends_on = [aws_lb.alb]
}

# Perform compilation of client package 
resource "null_resource" "create_client_package" {
  triggers = {
    always_run = "${timestamp()}"
  }

    provisioner "local-exec" {
    command = <<EOF
cd ${var.info_client_workspace}; mvn clean package; cp target/${var.jar_file_client} ${var.webapp_src_location_client}
EOF
  } # End of provisioner

    depends_on = [null_resource.update_server_dns]
}