resource "aws_launch_configuration" "asg-launch-config" {
  image_id          = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.busybox.id]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Terraform & AWS ASG" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
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
  name = "terraform-sample-elb-sg"
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
  min_size = 2
  max_size = 5
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
  value       = aws_elb.sample.dns_name
  description = "The domain name of the load balancer"
} 




