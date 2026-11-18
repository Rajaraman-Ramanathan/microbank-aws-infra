variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "admin_principals" {
  type    = list(string)
  default = []
}

variable "usage_principals" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "eks_provisioning_principals" {
  description = "IAM principals permitted to provision EKS using this KMS key"
  type        = list(string)
  default     = []
}