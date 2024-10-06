variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnet" {
  type        = map(object({
    cidr = string
    az = string
  }))
}
