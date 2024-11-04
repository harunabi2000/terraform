# main.tf

# Configure the AWS provider
provider "aws" {
  region = "eu-west-2"  # Replace with your preferred region
}

# Create a security group with HTTP and SSH access
resource "aws_security_group" "sg-ec2" {
  name = "TutorialSG"

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TutorialSG"
  }
}

# Create 3 EC2 instances
resource "aws_instance" "example" {
  count         = 3  # Number of instances
  ami           = "ami-0e1a523f05c744257"  # Replace with a valid AMI ID in your region
  instance_type = "t2.micro"  # Choose the instance type (t2.micro for AWS free tier)
  key_name      = "ansible"  # Replace with your actual key pair name

  # Associate the security group
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]

  tags = {
    Name = "ExampleInstance-${count.index + 1}"  # Name each instance uniquely
  }
}

# Output the public IP addresses of the instances
output "instance_public_ips" {
  value = aws_instance.example[*].public_ip
}
