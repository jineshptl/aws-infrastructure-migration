output "control_ip" {
  value = aws_instance.control.public_ip
}

output "worker_ips" {
  value = aws_instance.worker[*].public_ip
}

output "worker_ip" {
  value = aws_instance.worker[0].public_ip
}
