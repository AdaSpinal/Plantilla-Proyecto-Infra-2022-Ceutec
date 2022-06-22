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

resource "aws_instance" "app_server" {
ami     = "ami-0022f774911c1d690"
instance_type = "t2.micro"
key_name = "Llave-Ada"
security_groups = [aws_security_group.allow_all.name]

 tags = {
   Name = "Super_Mario_2022"
 }


}



