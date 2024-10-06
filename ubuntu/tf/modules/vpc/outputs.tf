output "id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = { for k, v in aws_subnet.public : k => v.id }
}
