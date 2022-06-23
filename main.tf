terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_launch_template" "SM" {
  name = "LT-Supermario-Ada"
  description = "Template for Super Mario Game"
  image_id = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  key_name = "Llave-Ada"

  vpc_security_group_ids = ["sg-04beabb75f4b4d46b"]
  user_data = "${filebase64("userdata.sh")}"
    tags = {
      Name = "Super_Mario_2022"
    }
}


resource "aws_autoscaling_group" "bar" {
  name= "AG-SuperMario-Ada"
  availability_zones = ["us-east-1a"]
  desired_capacity = 1
  max_size = 4
  min_size = 1 
  
  launch_template {
    id = aws_launch_template.SM.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "Proyecto_Super_Mario.2022"
    propagate_at_launch = true
  }
  

}

