provider "aws" {
  region = "us-east-1" # Replace with your desired region
  secret_key = var.secret_key
  access_key = var.access_key
}

# Output the Public IPs
output "um" {
  value = aws_instance.tres.public_ip
  
}

output "dois" {
  value = aws_instance.dois.public_ip
  
}

output "tres" {
  value = aws_instance.tres.public_ip
  
}