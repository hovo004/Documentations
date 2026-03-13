# ==================================================
#  Assigning a public IP address to an EC2 instance
# ==================================================

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI
  instance_type = "t2.micro"
  
  # Set to true for public IP
  associate_public_ip_address = true    #<<<<< If this not set, terraform wiil check into subnet, if subnet has map_public_ip_on_launch = true, then it will assign a public IP address to the instance

  tags = {
    Name = "PublicInstance"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Modify as needed
  map_public_ip_on_launch = true # This is the key setting
  tags = {
    Name = "public-subnet"
  }
}