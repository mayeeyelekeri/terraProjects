####  database ID/pasword coming from AWS Secrets Manager 
####  "mysql_user" and "mysql_password"
# Get db secrets from AWS Secret Manager 
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.mysql_creds 
}

locals {mysql_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)}


# Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_database_endpoint" {
  # This timestamps makes this resource to run all time, even if there is no change
  /*triggers = {
    always_run = "${timestamp()}"
  } */

    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost mysql_host=${local.mysql_creds.mysql_endpoint} \
mysql_port=${local.mysql_creds.mysql_port} \
mysql_user=${local.mysql_creds.mysql_user} \
mysql_password=${local.mysql_creds.mysql_password} \
mysql_database=${local.mysql_creds.mysql_database} \
src_file=${var.src_properties_file} \
dest_file=${var.dest_properties_file}" \
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner
}

# Perform compilation of server 
resource "null_resource" "create_package" {

  # This timestamps makes this resource to run all time, even if there is no change
  /*triggers = {
    always_run = "${timestamp()}"
  }*/
  provisioner "local-exec" {
    command = <<EOF
cd ${var.info_server_workspace}; mvn clean package; cp target/${var.jar_file} ${var.webapp_src_location}
EOF
  } # End of provisioner

    depends_on = [null_resource.update_database_endpoint]
}