output "subnets" {
  value = aws_subnet.subnets
}

output "vpc_id" {
  value = aws_vpc.lab1-vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.lab1-vpc.cidr_block
}
