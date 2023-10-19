# --- compute/outputs.tf ---

output "ubuntu_ami" {
  value = data.aws_ami.ubuntu
}
