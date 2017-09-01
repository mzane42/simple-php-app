### Variables
variable front_instance_number {
  default = "2"
}

variable front_ami {
  default = "ami-0d77397e" # Ubuntu 16.04
}

variable front_instance_type {
  default = "t2.micro"
}

variable public_key {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrAJS4BOKEPCjd8kwr29EZ4N3dpkSr5HGT+A7HJtBawryDR9irJVZXDm7NqmKa79hkPQZytTkaZo6BiIK+nD/phV76xnxTshqn0s4+WLVMfJopI48udkHwRBvbzpWV/FoLb7aBw4ibmul/SISnLx24sLOdY9JR2OXugcaBkejWEmEK0Qy83Ri8+g/S5sLDfMbruM4b0k8RqgICSgRJWtYrDTgMzFRdGyucJtu02UruWBzl25Rj853u8JL3Uzy5mlhK2hcY+MrRSY8h2sInbXXugNZ9ixkmeb0OCaYGD8FwQ32X7p2rzyxyL0REHXpeg0H4NUTkhy/tBaC6EOLnDUWbigELW0uKB/++lWMJx9nEyS+DQ7cqBOKgKULrZHRwrv8KD+lSJUN5RulB5+kTS/tTi71TA26x+tH9mraBQbcDL3PeYeVYPJMcQj9PevNjIVHiTAqDrDPrTONL2tEP5XrCMZ2KN4bNpvm/DqX7CmkXUWhbqSEl7iqcev+4q1h3iHYDOn9Z929jMfGFGCiqQ3dJcXVFTXZp4k8zxZELbbKzsRxMePAXEe/DG7YHnLsQAixzzy0MWnj6ZUYADLwca6kKp8g/rZhuv6hf6mVXJTu3LadMguBL1gGUSJgBrpEjxL+SysXXBwQw+u1T8S+9OYV9FEoNg/0csJZ9D2YYybjgvQ== crashcourse@devops.d2si"
}

variable front_elb_port {
  default = "80"
}

variable front_elb_protocol {
  default = "http"
}

### Resources
resource "aws_key_pair" "front" {
  key_name   = "${var.project_name}-front"
  public_key = "${var.public_key}"
}

resource "aws_instance" "front" {
  ami = "${var.front_ami}"
  subnet_id = "${aws_subnet.public.0.id}"
  instance_type = "${var.front_instance_type}" 
   tags {
    Name = "front_instance"
   }
}

resource "aws_elb" "front" {
    name               = "elb"
    subnets = ["${aws_subnet.public.*.id}"]
    listener {
      instance_port     = "8000"
      instance_protocol = "http"
      lb_port    = "${var.front_elb_port}"
      lb_protocol = "${var.front_elb_protocol}"
  }
}

### Outputs
output "elb_endpoint" {
  value = "${aws_elb.front.dns_name}"
  # TO DO
  # see https://www.terraform.io/intro/getting-started/outputs.html
}

output "instance_ip" {
  value = "${aws_instance.front.public_ip}"
  # TO DO
}
