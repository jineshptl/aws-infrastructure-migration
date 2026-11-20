data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}

# All nodes in one subnet so BGP next hops are reachable directly
data "aws_subnet" "lab" {
  availability_zone = "us-east-1c"
  default_for_az    = true
}

resource "aws_key_pair" "lab" {
  key_name   = "k8s-lab"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "k8s" {
  name = "k8s-lab"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "Nodes talk to each other"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "control" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.medium"
  key_name               = aws_key_pair.lab.key_name
  iam_instance_profile   = aws_iam_instance_profile.k8s.name
  vpc_security_group_ids = [aws_security_group.k8s.id]
  subnet_id              = data.aws_subnet.lab.id
  source_dest_check      = false
  root_block_device { volume_size = 20 }
  tags = { Name = "k8s-control", Role = "control" }
}

resource "aws_instance" "worker" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t4g.small"
  key_name               = aws_key_pair.lab.key_name
  iam_instance_profile   = aws_iam_instance_profile.k8s.name
  vpc_security_group_ids = [aws_security_group.k8s.id]
  subnet_id              = data.aws_subnet.lab.id
  source_dest_check      = false
  root_block_device { volume_size = 20 }
  tags = { Name = "k8s-worker-${count.index + 1}", Role = "worker" }
}
