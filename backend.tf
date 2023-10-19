# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "jenkins-bucket-samshen"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}
