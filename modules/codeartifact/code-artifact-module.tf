# Create CodeArtifact Domain  
resource "aws_codeartifact_domain" "domain" {
  domain = "${var.domain_name}"

  tags = {
    Name        = var.domain_name
    Environment = "dev"
  }
}  # codeartifact domain 

# Create CodeArtifact repository 
resource "aws_codeartifact_repository" "repo" {
  repository = "${var.repo_name}"

  tags = {
    Name        = var.repo_name
    Environment = "dev"
  }
}  # code Repo   

# Create CodeArtifact UpStream repository 
resource "aws_codeartifact_repository" "upstream_repo" {
  repository = "${var.upstream_repo_name}"

  tags = {
    Name        = var.upstream_repo_name
    Environment = "dev"
  }
}  # code Upstream Repo   


