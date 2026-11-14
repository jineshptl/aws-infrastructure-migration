output "app01_ip" {
  value = aws_instance.app01.public_ip
}

output "monitor01_ip" {
  value = aws_instance.monitor01.public_ip
}
