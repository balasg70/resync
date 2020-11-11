resource "aws_instance" "app" {
  ami           = lookup(var.AmiLinux, var.region)
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = aws_subnet.PublicAZA.id
  vpc_security_group_ids = [aws_security_group.WebApp.id]
  #key_name = var.key_name
  key_name = "Testkey"
  tags = {
        Name = "ec2_devops"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  yum update -y
  yum install -y httpd24 php56 php56-mysqlnd
  service httpd start
  chkconfig httpd on
  echo "<?php" >> /var/www/html/myApp.php
  echo "\$conn = new mysqli('mydatabase.ShaanAWSDNS.internal', 'root', 'secret', 'test');" >> /var/www/html/myApp.php
  echo "\$sql = 'SELECT * FROM Employees'; " >> /var/www/html/myApp.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/myApp.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'the value is: ' . \$row['NAME'],  \$row['ADDRESS'];} " >> /var/www/html/myApp.php
  echo "\$conn->close(); " >> /var/www/html/myApp.php
  echo "?>" >> /var/www/html/myApp.php	
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
