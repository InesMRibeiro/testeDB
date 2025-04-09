# Flask API Server (Instance 1)
resource "aws_instance" "tres" {
  ami           = var.ami_id # Replace with your AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.SG_testeDB.name]
  key_name = "RSA_key"
 

  tags = {
    Name = "3"
  }
}