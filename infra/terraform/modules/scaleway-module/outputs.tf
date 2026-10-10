output "instance_public_ip" {
  value       = length(scaleway_instance_server.web.public_ips) > 0 ? scaleway_instance_server.web.public_ips[0].address : "nada" # The actual value to be outputted
  description = "The public IP address of the scaleway instance"                                                                  # Description of what this output represents
  sensitive   = true
}