# Create CodeArtifact repository 
resource "aws_codeartifact_repository" "repo" {
  repository = "${var.repo_name}"
  domain = "${var.codeartifact_domain_name}"

  tags = {
    Name        = var.repo_name
    Environment = "dev"
  }
}  # code Repo   

data "aws_codeartifact_repository_endpoint" "endpoint" {
  domain = "${var.codeartifact_domain_name}"
  repository = aws_codeartifact_repository.repo.repository
  format     = "maven"
}


