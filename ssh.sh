ip=$(terraform output -json instance_ip_addr | jq .[].[] -r | tail -n 1)
echo $ip
ssh ubuntu@$ip -i ../secs/ssh.aws.mars.keyfile
