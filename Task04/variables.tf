
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"

}

variable "instance_type" {

  type    = string
  default = "t2.micro"

}

variable "instance_ami" {

  type    = string
  default = "ami-0ad21ae1d0696ad58"

}
