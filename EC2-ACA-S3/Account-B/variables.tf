variable "account_name" {
  description = "In which acoount"
  type        = string
  default     = "Account-B"
}

variable "project_name" {
  description = "Name of the Project"
  type        = string
  default     = "EC2-CrossAccount-AccesstoS3"
}

variable "project_maker" {
  description = "Name of the project performer"
  type        = string
  default     = "Sandeeep"

}

variable "contact_email" {
  description = "Email address of the maker"
  type        = string
  default     = "sandeep.chinta0102@gmail.com"

}

variable "iac_framework" {
  description = "Infrastrucher as code type"
  type        = string
  default     = "Terraform"

}