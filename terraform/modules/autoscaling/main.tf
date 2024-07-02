#Used for Monitoring Processing Power
resource "aws_autoscaling_group" "wordpress" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.public_subnet_ids
  launch_configuration = aws_launch_configuration.wordpress.id

  tag {
    key                 = "Name"
    value               = "wordpress_instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "wordpress" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = [var.security_group_id]
  key_name        = var.ec2_ssh_key

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
}