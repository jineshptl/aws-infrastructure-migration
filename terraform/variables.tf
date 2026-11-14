variable "region" {
  type    = string
  default = "us-east-1"
}

variable "admin_cidr" {
  description = "Your public IP with /32"
  type        = string

  validation {
    condition     = var.admin_cidr != "0.0.0.0/0"
    error_message = "Don't open admin ports to the whole internet."
  }
}
