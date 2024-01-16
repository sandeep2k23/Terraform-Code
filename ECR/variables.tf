variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}

  validation {
    condition = can(length(var.tags["BusinessFunction"])) ? length(var.tags["BusinessFunction"]) >= 2 : false
    error_message = "BusinessFunction tag is required, It can't be null or Empty and minimum length should be 2!"
  }

  validation {
    condition = can(length(var.tags["OwnerEmail"])) ? (length(var.tags["OwnerEmail"]) >= 2) && (length(regexall("^[\\w-._]+@syngenta.+[a-z]{2,4}$", var.tags["OwnerEmail"])) > 0): false //&& can(length(var.tags["OwnerEmail"] >= 2)) //&& can(regex("^[a-z0-9]+@syngenta.+[a-z]{2,4}$", var.tags["OwnerEmail"]))
    error_message = "OwnerEmail tag is required, It can't be null or Empty and should be syngenta mail id"
  }

  validation {
    condition = can(length(var.tags["ContactEmail"])) ? (length(var.tags["ContactEmail"]) >= 2) && (length(regexall("^[\\w-._]+@syngenta.+[a-z]{2,4}$", var.tags["ContactEmail"])) > 0): false //&& can(length(var.tags["OwnerEmail"] >= 2)) //&& can(regex("^[a-z0-9]+@syngenta.+[a-z]{2,4}$", var.tags["OwnerEmail"]))
    error_message = "ContactEmail tag is required, It can't be null or Empty and should be syngenta mail id"
  }

  validation {
    condition = can(length(var.tags["Application"])) ? length(var.tags["Application"]) >= 2 : false
    error_message = "Application tag is required, It can't be null or Empty!"
  }

  validation {
    condition = can(length(var.tags["Environment"])) ? length(var.tags["Environment"]) >= 2 && (length(regexall("^(Development|Test|Stage|Production)$", var.tags["Environment"])) > 0) : false
    error_message = "Environment tag is required, It can't be null or Empty! Correct values are Development or Test or Stage or Production"
  }

  validation {
    condition = can(length(var.tags["Platform"])) ? length(var.tags["Platform"]) >= 2 : false
    error_message = "Platform tag is required, It can't be null or Empty!"
  }

  validation {
    condition = can(length(var.tags["CostCenter"])) ? length(var.tags["CostCenter"]) >= 2 : false
    error_message = "CostCenter tag is required, It can't be null or Empty!"
  }

  validation {
    condition = can(length(var.tags["CreatedByEmail"])) ? (length(var.tags["CreatedByEmail"]) >= 2) && (length(regexall("^[\\w-._]+@syngenta.+[a-z]{2,4}$", var.tags["CreatedByEmail"])) > 0): false //&& can(length(var.tags["OwnerEmail"] >= 2)) //&& can(regex("^[a-z0-9]+@syngenta.+[a-z]{2,4}$", var.tags["OwnerEmail"]))
    error_message = "CreatedByEmail tag is required, It can't be null or Empty and should be syngenta mail id"
  }

}

variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
  validation {
    condition = contains(["private","public"],var.repository_type)?true:false
    error_message = "Repository Type should be either alias or version only. It's case-sensitive."
  }
}

################################################################################
# Repository
################################################################################

variable "create_repository" {
  description = "Determines whether a repository will be created"
  type        = bool
  default     = true
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = ""
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  type        = string
  default     = "AES256"
}

variable "repository_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = true
}

variable "repository_policy" {
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  type        = string
  default     = null
}

variable "repository_force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = false
}

################################################################################
# Repository Policy
################################################################################

variable "attach_repository_policy" {
  description = "Determines whether a repository policy will be attached to the repository"
  type        = bool
  default     = false
}

variable "create_repository_policy" {
  description = "Determines whether a repository policy will be created"
  type        = bool
  default     = true
}

variable "repository_read_access_arns" {
  description = "The ARNs of the IAM users/roles that have read access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_lambda_read_access_arns" {
  description = "The ARNs of the Lambda service roles that have read access to the repository"
  type        = list(string)
  default     = []
}

variable "repository_read_write_access_arns" {
  description = "The ARNs of the IAM users/roles that have read/write access to the repository"
  type        = list(string)
  default     = []
}

################################################################################
# Lifecycle Policy
################################################################################

variable "create_lifecycle_policy" {
  description = "Determines whether a lifecycle policy will be created"
  type        = bool
  default     = false
}

variable "repository_lifecycle_policy" {
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  type        = string
  default     = ""
}

################################################################################
# Public Repository
################################################################################

variable "public_repository_catalog_data" {
  description = "Catalog data configuration for the repository"
  type        = any
  default     = {}
}

################################################################################
# Registry Policy
################################################################################

variable "create_registry_policy" {
  description = "Determines whether a registry policy will be created"
  type        = bool
  default     = false
}

variable "registry_policy" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = null
}


################################################################################
# Registry Scanning Configuration
################################################################################

variable "manage_registry_scanning_configuration" {
  description = "Determines whether the registry scanning configuration will be managed"
  type        = bool
  default     = false
}

variable "registry_scan_type" {
  description = "the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`"
  type        = string
  default     = "ENHANCED"
}

variable "registry_scan_rules" {
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur"
  type        = any
  default     = []
}

################################################################################
# Registry Replication Configuration
################################################################################

variable "create_registry_replication_configuration" {
  description = "Determines whether a registry replication configuration will be created"
  type        = bool
  default     = false
}

variable "registry_replication_rules" {
  description = "The replication rules for a replication configuration. A maximum of 10 are allowed"
  type        = any
  default     = []
}


