# Create EFS 
resource "aws_efs_file_system" "myefs" {
  tags = {
    Name = join("-", ["${terraform.workspace}", "myefs"])
    Environment = "${terraform.workspace}"
  }
} 

