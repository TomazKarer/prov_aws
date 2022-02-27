[hosts]
%{ for ip in hosts ~}
${ip} ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}
