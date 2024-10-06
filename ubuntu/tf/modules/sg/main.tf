resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Name = format("%s-sg", var.name)
  }
}
