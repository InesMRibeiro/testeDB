# Flask API Server (Instance 1)
resource "aws_instance" "dois" {
  ami           = var.ami_id # Replace with your AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.SG_testeDB.name]
  key_name = "RSA_key"
 

  tags = {
    Name = "2"
  }


  
      user_data = <<-EOF
                #!/bin/bash
                exec > /var/log/user-data.log 2>&1  # Redirect output to log file
                set -x  # Enable debugging

                echo "Starting backend server setup..."

                cd /home/ubuntu
                if [ ! -d "testesDB" ]; then
                    git clone https://github.com/InesMRibeiro/testeDB.git
                else
                    echo "Repository already cloned."
                fi

                sudo apt update -y
                sudo apt install -y python3 python3-pip python3-venv git

                python3 -m venv venv
                source venv/bin/activate

                cd testesDB/backend

                if [ -f "requirements.txt" ]; then
                     pip install -r requirements.txt
                else
                     echo "requirements.txt not found!" >> /var/log/user-data.log
                fi
                echo "Backend server setup completed!"

                # Mark the directory as safe for Git operations
                export HOME=/home/ubuntu
                git config --global --add safe.directory /home/ubuntu/testesDB

                sudo chown -R ubuntu:ubuntu /home/ubuntu/testesDB

                EOF
}