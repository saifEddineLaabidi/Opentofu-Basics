resource "aws_instance" "ruby" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.name
  key_name      = var.key_name
  tags = {
    Name = each.value
  }
}
output "instances" {
 value = aws_instance.ruby
}
resource "aws_instance" "jade-mw" {

}

# aws ec2 describe-instances --endpoint http://aws:4566  --filters "Name=image-id,Values=ami-082b3eca746b12a89" | jq -r '.Reservations[].Instances[].InstanceId'
# tofu import