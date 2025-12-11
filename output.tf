#print app-server ip
output "public_ip" {
  value = "aws_instance.public_server.public_ip"
}
# print db-server ip
output "privete_ip" {
  value = "aws_instance.private-server.private_ip"
}