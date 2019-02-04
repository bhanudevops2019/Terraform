resource "aws_launch_configuration" "launch-config" {
  name                  = "student-config"
  image_id              = "${var.AMI_ID}"
  instance_type         = "${var.INSTANCE_TYPE}"
  iam_instance_profile  = "${aws_iam_instance_profile.ec2-profile.name}"
  key_name              = "devops"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install ansible git python2-pip -y
              sudo pip install awscli
              EOF
  security_groups       = ["${aws_security_group.ec2-sg.id}"]
}

resource "aws_autoscaling_group" "asg" {
  name                      = "studentapp-dev-asg"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  #placement_group           = "${aws_placement_group.test.id}"
  launch_configuration      = "${aws_launch_configuration.launch-config.name}"
  vpc_zone_identifier       = ["${var.PUBLIC_SUBNETS}"]

}
