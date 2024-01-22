resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-template"
  image_id      = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"

  key_name               = "ec2ecsglog"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  iam_instance_profile {
    name = "arn:aws:iam::889142710491:instance-profile/ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/ecs.sh")
}