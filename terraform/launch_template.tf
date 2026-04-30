# ------------------------------------------------------------------------------
# Amazon Linux 2023 AMI
# ------------------------------------------------------------------------------

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------------------------------------
# EC2 launch template for the application tier
# ------------------------------------------------------------------------------

resource "aws_launch_template" "webapp" {
  name        = "ha-webapp-launch-template"
  description = "Launch template for the highly available web app instances"

  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    AZ=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
    HOSTNAME=`hostname -f`
    echo "<h1>Highly Available Web App</h1><p>Hostname: $HOSTNAME</p><p>AZ: $AZ</p>" > /var/www/html/index.html
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ha-webapp-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "ha-webapp-volume"
    }
  }

  tags = {
    Name = "ha-webapp-launch-template"
  }
}
