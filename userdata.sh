#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -g docker ec2-user
sudo systemctl enable docker 
sudo docker run -d -p 8600:8080 bharathshetty4/supermario

