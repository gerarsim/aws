variable "aws_region" { 
    default = "ca-central-1"
  }

provider "aws" {
    region = "${var.aws_region}"
    access_key = "AKIA3NSJORM7LS3EBSBJ"
    secret_key = "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"
  
}
resource "aws_key_pair" "admin" {
  key_name = "admin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEfmgyuOoaJV9MdT7/SBNQv2lIJ/Lr9l/GCflTU4CklWYkpUrRgggyc0N18gv/4PgSqP0yUof8Um1AqVy4JI4/QSjxCh9gyWvsFSfQKo7MSEE/9QLOslwytPDudaRmy5vXowZyPu7fyd/w/4s22ijSJG3e6LR7pFdCNXUWKBHMwpXgQw+sv7P+pMBbmfd8nhCCHGtFoMtsk/txb1mt0300TEOpblx17AzJ4Z+eZHEWHevwZlav2sPFoFajypO4XePvJE+MJca0lEIYrS8wmRhN3lmN/obz5daEuJ8jCjKen2NXDraWgCuJpJSDx3zo17xOoQQVUgRHJP/kXetJOqaV sam@MacSam.local"

}
resource "aws_key_pair" "ansible" {
  key_name = "ansible-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHYFod3nW0C4bJVX71sGh2jiudP+15qImlQRgaYp+H6CZO11sfT8PLx37k3I7oOBdzIZftGZsE6jbJnKj3wzM+6V1oaxXFcMf9mUFuA87psNtqtG07o8UsH6t+5j76CZp1H72TcX8QxVM0P4ZmBl988bVelQU7gCKHaYyOoEge+/qaB+BbRyEDan8HAO64ePT2U0/BPW+MCDxxNf0zfzZAxb2flfSxDICi2qZfF9YlDc46dLqNricHQmXN7qoa1On0gE0G5E6pfrrrRCN+OnjIhQ6p8h8odrC+DEo9R8TyahQsqFbt2UZr9uKhjuX0ds1Y2erJOTlK+wJgBPPlc05v sam@MacSam.local"
  
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