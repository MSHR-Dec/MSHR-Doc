data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = {
    Name = var.name
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  for_each = var.instance

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.this.name
  vpc_security_group_ids      = var.sg_ids
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    kubernetes_version = var.kubernetes_version
    containerd_version = var.containerd_version
    runc_version       = var.runc_version
    cni_version        = var.cni_version
  })

  root_block_device {
    volume_type = "gp3"
    volume_size = 128
  }


  tags = {
    Name = each.key
  }
}
