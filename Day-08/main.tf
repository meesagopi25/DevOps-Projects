
provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}
resource "aws_instance" "web_server" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = "kp1"
  tags          = { Name = "Jenkins-Provisioned-Node" }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}
