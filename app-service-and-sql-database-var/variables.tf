variable "resource-group-name" {
  default     = "PSM-TEST-TF"
  description = "The prefix used for all resources in this example"
}

variable "app-service-name" {
  default     = "PSM-TEST-TF-AP"
  description = "The name of the Web App"
}

variable "location" {
  default     = "Korea Cental"
  description = "The Azure location where all resources in this example should be created"
}