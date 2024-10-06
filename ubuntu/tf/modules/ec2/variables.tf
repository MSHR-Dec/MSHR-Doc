variable "sg_ids" {
  type = list(string)
}

variable "instance" {
  type = map(object({
    subnet_id = string
  }))
}

variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "kubernetes_version" {
  type = string
}

variable "containerd_version" {
  type = string
}

variable "runc_version" {
  type = string
}

variable "cni_version" {
  type = string
}
