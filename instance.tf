resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "cwdemo" {
  ami                       = var.AMIS[var.AWS_REGION]
  instance_type             = "t3a.micro"
  key_name                  = aws_key_pair.mykey.key_name
  vpc_security_group_ids    = [aws_security_group.ssh_http.id]
  subnet_id                 = aws_subnet.public-1a.id
  iam_instance_profile      = aws_iam_instance_profile.demo_profile.name

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm",
      "sudo yum install amazon-cloudwatch-agent -y",
      "sudo systemctl start amazon-ssm-agent",
      "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-Amazon2Linux-Basic"
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
  tags = {
    Name = "cw_demo_2207"
  }
}

output "public_ip" {
  value       = aws_instance.cwdemo.public_ip
}

output "instance_id" {
  value       = aws_instance.cwdemo.id
}