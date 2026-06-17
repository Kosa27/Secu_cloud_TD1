[bastion]
${bastion_ip}

[cible]
${cible_ip}

[cible:vars]
ansible_ssh_common_args='-o ProxyJump=ec2-user@${bastion_ip}'
