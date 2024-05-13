variable "vpc_cidr" {
  type = string
}

variable "cidr_zero" {
  type = string
}

variable "tag" {
  type = string
}

variable "region" {
  type = string
}

variable "machine_details" {
  type = object({
    type      = string,
    ami       = string,
    public_ip = bool
  })
}

variable "subnets_details" {
  type = list(object({
    name              = string,
    cidr              = string,
    type              = string,
    availability_zone = string

  }))
}

variable "db_pass" {
  type      = string
  sensitive = true
}

