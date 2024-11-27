// AWS Provider Configuration
provider "aws" {
  region = "eu-west-2"
}

// RSA Key Pair
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// creating Private Key Locally
resource "local_file" "private_key" {
  content         = tls_private_key.keypair.private_key_pem
  filename        = "kube-key.pem"
  file_permission = "600"
}

// creating ec2 Key Pair
resource "aws_key_pair" "keypair" {
  key_name   = "kube-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

// Security Group for Cluster
resource "aws_security_group" "kube_sg" {
  name        = "kube-cluster-sg"
  description = "Allow inbound traffic for Kubernetes Cluster"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kube-cluster-sg"
  }
}

// EC2 Instance: Master Node
resource "aws_instance" "master" {
  ami                    = "ami-0e8d228ad90af673b" // ubuntu instance
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.kube_sg.id]
  key_name               = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  user_data              = file("./master-userdata.sh")

  tags = {
    Name = "master-node"
  }
}

// EC2 Instances: Worker Nodes
resource "aws_instance" "worker" {
  count                  = 2
  ami                    = "ami-0e8d228ad90af673b" // ubuntu instance
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.kube_sg.id]
  key_name               = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  user_data              = file("./worker-userdata.sh")

  tags = {
    Name = "worker-node-${count.index}"
  }
}

// Outputs
output "master" {
  value = aws_instance.master.public_ip
}
output "worker_nodes" {
  value = aws_instance.worker.*.public_ip
}
