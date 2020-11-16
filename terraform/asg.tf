resource "aws_launch_configuration" "asg-launch-config" {
  image_id          = "ami-08569b978cc4dfa10"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.busybox.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y git golang postgresql10 postgresql10-server postgresql10-contrib postgresql10-libs docker
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
              git clone https://github.com/servian/TechChallengeApp
              cd TechChallengeApp
              go get -d github.com/Servian/TechChallengeApp
              ./build.sh
              cd dist
              ./TechChallengeApp updatedb
              ./TechChallengeApp serve
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "busybox" {
  name = "terraform-busybox-sg"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-sg" {
  name = "terraform-elb-sg"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.asg-launch-config.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 1
  max_size = 3
  desired_capacity = 2

  load_balancers    = [aws_elb.elbsg.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}

resource "aws_elb" "elbsg" {
  name               = "terraform-asg"
  security_groups    = [aws_security_group.elb-sg.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Adding a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}    

output "elb_dns_name" {
  value       = aws_elb.dns_name
  description = "The domain name of the load balancer"
}


