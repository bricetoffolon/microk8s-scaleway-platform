resource "scaleway_instance_server" "web" {
  project_id = var.project_id
  type       = var.instance_type
  image      = "debian_bookworm"

  ip_id = scaleway_instance_ip.public_ip.id

  root_volume {
    size_in_gb = var.volume_size_in_gb
  }

  security_group_id = scaleway_instance_security_group.www.id

  user_data = {
    cloud-init = <<-EOF
      #cloud-config
      users:
        - name: ${var.scaleway_ansible_user}
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh_authorized_keys:
            - ${var.ssh_key}

      runcmd:
        - chmod 440 /etc/sudoers.d/ansible
        - mkdir -p /home/ansible/.ssh
        - chmod 700 /home/ansible/.ssh
        - chmod 600 /home/ansible/.ssh/authorized_keys
        - chown -R ansible:ansible /home/ansible/.ssh
    EOF
  }
}