#data "aws_subnet" "k8s" {
#  id = var.lambda_function_vpc_subnet_ids[0]
#}
# 
#resource "aws_security_group" "fis" {
#  name_prefix = "${var.name}-"
#  vpc_id      = data.aws_subnet.k8s.vpc_id
#
#  tags = merge(var.extra_tags, tomap({
#    Name      = var.name
#    BuiltWith = "terraform"
#  }))
#}
#
#resource "aws_security_group_rule" "fis" {
#  type              = "egress"
#  security_group_id = aws_security_group.fis.id
#
#  protocol    = "-1"
#  cidr_blocks = ["0.0.0.0/0"]
#  from_port   = 0
#  to_port     = 0
#}
