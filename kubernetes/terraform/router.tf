# FRR router that peers with Cilium over BGP
resource "aws_instance" "router" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.micro"
  key_name               = aws_key_pair.lab.key_name
  iam_instance_profile   = aws_iam_instance_profile.k8s.name
  vpc_security_group_ids = [aws_security_group.k8s.id]
  subnet_id              = data.aws_subnet.lab.id
  source_dest_check      = false
  tags                   = { Name = "k8s-router", Role = "router" }
}
