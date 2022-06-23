resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_alb_target_group" "target-group" {
    health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    } 
    
      

    name ="SuperMarioTargetGroup"
    port = 8600
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = data.aws_vpc.default.id
    stickiness {
      type = "lb_cookie"
    }
    
  
}

#Instance Attachment
resource "aws_autoscaling_attachment" "svc_asg_external2" {
  alb_target_group_arn = "${aws_alb_target_group.target-group.arn }"
  autoscaling_group_name = "${aws_autoscaling_group.bar.id}" 
  
}

resource "aws_alb" "application-alb" {
    name = "LB-ProyectoSuperMario"
    internal  = false
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = ["sg-028e0d5f7222fc799"]
    subnets = data.aws_subnet_ids.subnet.ids

        tags = {
          Name = "App alb"
        }

}


resource "aws_alb_listener" "alb-listener" {
    load_balancer_arn = aws_alb.application-alb.arn 
    port              = 80
    protocol          = "HTTP"
    default_action{
        target_group_arn = aws_alb_target_group.target-group.arn 
        type = "forward"
    } 

  
}


