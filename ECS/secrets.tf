module  "secret" {

    source  = "https://github.com/sandeep2k23/Terraform/blob/ECR/secretsmanager.tf"
    version = "1.0.1"
    for_each = var.secrets
        secret_name = "${lower(var.application)}/${lower(var.environment)}${each.value.secret_name}"
        secret_string = each.value.secret_string
        secret_description = "Used by ECS service - ${lower(var.application)}/${each.value.name} as configuration."
        tags = local.tags
        kms_key_id = module.kms.key_id
        enable_secret_rotation = false
}  