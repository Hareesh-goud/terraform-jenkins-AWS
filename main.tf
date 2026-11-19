terraform {

   required_providers {

     aws = {

       source  = "hashicorp/aws"

       version = "~> 6.0"

     }

 }

 }
 
provider "aws" {

   region = "ap-southeast-2"

 }

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform-VPC"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone      = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Public-Subnet"
  }
}

data "aws_ami" "ubuntu" {


   most_recent = true

   owners      = ["099720109477"] # Canonical
 
  filter {

     name   = "name"

     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]

   }

 }
 
resource "aws_instance" "jenkins_vm" {

   ami           = data.aws_ami.ubuntu.id

   instance_type = "t3.micro"
 
  tags = {

     Name = "Terraform-Jenkins-VM"

   }

 }
output "instance_public_ip" {

   value = aws_instance.jenkins_vm.public_ip

 }
 
