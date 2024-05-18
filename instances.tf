# ===== SG allowing SSH from 0.0.0.0/0 =====  
resource "aws_security_group" "ssh_from_anywhere" {
  name        = "ssh-from-anywhere"
  description = "Allow SSH access from anywhere"
  vpc_id      = module.network-lab2.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_zero]
  }
  # egress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [var.cidr_zero]
  # }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"   
    cidr_blocks     = ["0.0.0.0/0"] 
  }
}

# ===== SG allowing SSH and Port 3000 from VPC CIDR only ===== 
resource "aws_security_group" "ssh_and_3000" {
  name        = "ssh-and-3000-from-vpc"
  description = "Allow SSH and port 3000 access from VPC CIDR only"
  vpc_id      = module.network-lab2.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.network-lab2.vpc_cidr]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [module.network-lab2.vpc_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"   
    cidr_blocks     = ["0.0.0.0/0"] 
  }
}

# ===== Key Pair Generation ===== 
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "lab1-keypair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "keys/terraform-keylab1.pem"
}

# ===== Bastion EC2 ===== 
resource "aws_instance" "bastion" {
  ami                         = var.machine_details.ami
  instance_type               = var.machine_details.type
  subnet_id                   = module.network-lab2.subnets[0].id
  key_name                    = aws_key_pair.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.ssh_from_anywhere.id]
  associate_public_ip_address = var.machine_details.public_ip

  user_data = <<-EOF
    #!/bin/bash
    echo '${tls_private_key.key_pair.private_key_pem}' > /home/ubuntu/key.pem
    chmod 400 /home/ubuntu/key.pem
    chown ubuntu:ubuntu /home/ubuntu/key.pem
  EOF
  
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> bstianIP.txt"
  }
}

# ===== app EC2 ===== 
resource "aws_instance" "app" {
  ami                    = var.machine_details.ami
  instance_type          = var.machine_details.type
  subnet_id              = module.network-lab2.subnets[1].id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ssh_and_3000.id]
}
