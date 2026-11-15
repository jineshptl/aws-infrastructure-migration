variable "region" {
  default = "us-east-1"
}

variable "my_ip" {
  description = "Your home IP, only this IP can SSH in"
}

variable "public_key_path" {
  default = "~/.ssh/k8s-lab.pub"
}
