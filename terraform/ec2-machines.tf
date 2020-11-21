resource "aws_instance" "app" {
  ami           = lookup(var.AmiLinux, var.region)
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = aws_subnet.PublicAZA.id
  vpc_security_group_ids = [aws_security_group.WebApp.id]
  key_name = var.key_name
  #key_name = "Testkey"
  tags = {
        Name = "ec2_devops"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y git postgresql10 postgresql10-server postgresql10-contrib postgresql10-libs docker
  #service start
  sudo systemctl enable docker.service
  sudo systemctl enable postgresql.service
  sudo systemctl start docker.service
  sudo cat <<EOF >>/var/lib/pgsql/data/pg_hba.conf
  local	all	all	trust
  host	all	127.0.0.1/32	trust
  EOF
  sudo systemctl start postgresql.service
  #chkconfig httpd on
  git clone https://gitlab.com/jjneojiajun/resync-devops-test
  cd resync-devops-test
  python app/app.py
  HEREDOC
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_eip" "default" {
  vpc = true

  instance                  = aws_instance.app.id
  #associate_with_public_ip  = "10.0.0.12"
  depends_on                = [aws_internet_gateway.gw]
}

resource "local_file" "pem_file" { 
  filename = "${path.module}/demotest.pem"
  content = tls_private_key.example.private_key_pem
}
