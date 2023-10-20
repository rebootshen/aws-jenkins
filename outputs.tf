# --- root/outputs.tf ---

output "test_alb_dns" {
  description = "dns of static website"
  value = module.network.test_alb_dns
}