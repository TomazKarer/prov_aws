terraform apply
(
  cd ./ansible
  ansible-playbook playbook.yml -i ./inventory/hosts.cfg -u ubuntu --p ../../secs/ssh.aws.mars.keyfile
  cd ..
)

