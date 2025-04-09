# Flask API Server (Instance 1)
resource "aws_instance" "um" {
  ami           = var.ami_id # Replace with your AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.SG_testeDB.name]
  key_name = "RSA_key"
 

  tags = {
    Name = "1"
  }

     user_data = <<-EOF
                #!/bin/bash
                exec > /var/log/user-data.log 2>&1
                set -x  # Enables debugging


                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl enable apache2
                sudo systemctl start apache2

                cd /var/www/html
                echo "<h1>Deploying Frontend</h1>" > index.html

                cd /home/ubuntu
                if [ ! -d "testes" ]; then
                git clone https://github.com/InesMRibeiro/testes.git
                fi
                sudo cp  -r testes/frontend/* /var/www/html/

                # Mark the directory as safe for Git operations
                export HOME=/home/ubuntu
                git config --global --add safe.directory /home/ubuntu/testes

                sudo chown -R ubuntu:ubuntu /home/ubuntu/testes

                EOF

}