
locals {
  vars = {
    db_username = var.db_username
    db_password = var.db_password
    mediawiki_major_version = var.mediawiki_major_version
    mediawiki_minor_version = var.mediawiki_minor_version
  }
}

resource "aws_instance" "ec2wiki" {
  count                  = length(var.subnets_cidr_public)
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.keyname
  subnet_id              = aws_subnet.publicSubnet[count.index].id
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64encode(templatefile("${path.module}/user_data.sh", local.vars))

  tags = {
    Name  = "mediawiki-${count.index + 1}"
  }
}
