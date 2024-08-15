output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "security_group_name" {
  description = "ID of the EC2 instance"
  value       = aws_security_group.test.name
}