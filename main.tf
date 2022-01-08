variable "aws_region" { 
    default = "ca-central-1"
  }

provider "aws" {
    region = "${var.aws_region}"
    access_key = ""
    secret_key = ""
  
}
resource "aws_key_pair" "admin" {
  key_name = "admin-key"
  public_key = "BAAABAQDEfmgyuOoaJV9MdT7/SBNQv2lIJ/Lr9l/GCflTU4CklWYkpUrRgggyc0N18gv/4PgSqP0yUof8Um1AqVy4JI4/QSjxCh9gyWvsFSfQKo7MSEE/9QLOslwytPDudaRmy5vXowZyPu7fyd/w/4s22ijSJG3e6LR7pFdCNXUWKBHMwpXgQw+sv7P+pMBbmfd8nhCCHGtFoMtsk/txb1mt0300TEOpblx17AzJ4Z+eZHEWHevwZlav2sPFoFajypO4XePvJE+MJca0lEIYrS8wmRhN3lmN/obz5daEuJ8jCjKen2NXDraWgCuJpJSDx3zo17xOoQQVUgRHJP/kXetJOqaV sam@MacSam.local"

}
resource "aws_key_pair" "ansible" {
  key_name = "ansible-key"
  public_key = "BAAABAQDHYFod3nW0C4bJVX71sGh2jiudP+15qImlQRgaYp+H6CZO11sfT8PLx37k3I7oOBdzIZftGZsE6jbJnKj3wzM+6V1oaxXFcMf9mUFuA87psNtqtG07o8UsH6t+5j76CZp1H72TcX8QxVM0P4ZmBl988bVelQU7gCKHaYyOoEge+/qaB+BbRyEDan8HAO64ePT2U0/BPW+MCDxxNf0zfzZAxb2flfSxDICi2qZfF9YlDc46dLqNricHQmXN7qoa1On0gE0G5E6pfrrrRCN+OnjIhQ6p8h8odrC+DEo9R8TyahQsqFbt2UZr9uKhjuX0ds1Y2erJOTlK+wJgBPPlc05v sam@MacSam.local"
  
}

 # Get default VPC
resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
}


resource "aws_subnet" "web-public-2" {
    cidr_block = "172.31.60.0/27"
    availability_zone = "${var.aws_region}a"
    vpc_id     = "${aws_default_vpc.default.id}"

    tags = {
        Name = "Web"
    }
}

resource "aws_subnet" "bd-private-2" {
    cidr_block = "172.31.50.0/27"
    availability_zone = "${var.aws_region}a"
    vpc_id     = "${aws_default_vpc.default.id}"

    tags = {
        Name = "BD"
    }
}

# Security Group

resource "aws_security_group" "allow_remote_admin" {
  name        = "allow_remote_admin"
  description = "Allow ssh and RDP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_remote_admin"
  }
}
resource "aws_security_group" "allow_external_communication" {
  name        = "allow_external_communication"
  description = "Allow system reach other servers"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_external_comm"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web traffic to server"

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_security_group" "allow_mysql_internal" {
  name        = "allow_mysql_internal"
  description = "Allow Mysql connexion from web server"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.web-public-2a.cidr_block}"]
  }

  tags = {
    Name = "allow_mysql_internal"
  }
}
