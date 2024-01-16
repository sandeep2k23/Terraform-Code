output "s3_bucket_name_data" {
  value = module.s3_bucket["${var.bucket_stars_name}"].s3_bucket_id
}

output "s3_bucket_name_viva_export" {
  value = module.s3_bucket["${var.bucket_viva_export_name}"].s3_bucket_id
}

output "webportal_tg_arn" {
  value = module.alb.target_group_arns
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value = module.kms.key_arn
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value = module.kms.key_id
}

output "db_endpoint" {
  description = "The globally unique identifier for the key"
  value = module.db.db_endpoint
}

output "db_port" {
  description = "The globally unique identifier for the key"
  value = module.db.db_port
}

output "db_identifier" {
  description = "The globally unique identifier for the key"
  value = module.db.db_identifier
}