variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "availbility_zone" {}
variable "cidr_private_subnet" {}

output "project_pipline_vpc_id" {
  value = aws_vpc.project_pipline.id
}

output "project_pipline_public_subnets" {
  value = aws_subnet.project_pipline_public_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.project_pipline_public_subnets.*.cidr_block
}
# Setup VPC
resource "aws_vpc" "project_pipline" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Setup public subnet
resource "aws_subnet" "project_pipline_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.project_pipline.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.availbility_zone, count.index)

  tags = {
    Name = "terraform-jekins-public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "project_pipline_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.project_pipline.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.availbility_zone, count.index)

  tags = {
    Name = "terraform-jekins-private-subnet-${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "project_pipline_ig" {
  vpc_id = aws_vpc.project_pipline.id
  tags = {
    Name = "terraform-jenkins-1-igw"
  }
}

# Public Route Table
resource "aws_route_table" "project_pipline_public_route_table" {
  vpc_id = aws_vpc.project_pipline.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_pipline_ig.id
  }
  tags = {
    Name = "terraform-jenkins-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "project_pipline_public_rt_association" {
  count          = length(aws_subnet.project_pipline_public_subnets)
  subnet_id      = aws_subnet.project_pipline_public_subnets[count.index].id
  route_table_id = aws_route_table.project_pipline_public_route_table.id
}

# Private Route Table
resource "aws_route_table" "project_pipline_private_route_table" {
  vpc_id = aws_vpc.project_pipline.id
  tags = {
    Name = "terraform_jenkins_private_rt"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "project_pipline_private_rt_association" {
  count          = length(aws_subnet.project_pipline_private_subnets)
  subnet_id      = aws_subnet.project_pipline_private_subnets[count.index].id
  route_table_id = aws_route_table.project_pipline_private_route_table.id
}
