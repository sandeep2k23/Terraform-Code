module "kms" {
    source  = "https://github.com/sandeep2k23/Terraform/blob/ECR/kms.tf"
    version = "1.0.1"
    description = "KMS key for ${lower(var.application)} application on ${lower(var.environment)} environment."
    alias = "${lower(var.application)}-${lower(var.environment)}"
    tags = local.tags
}