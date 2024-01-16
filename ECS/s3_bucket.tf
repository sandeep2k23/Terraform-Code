module "s3_bucket" {
  for_each = toset([var.bucket_stars_name, var.bucket_viva_export_name])
  source  = "app.terraform.io/syngenta-tfc/s3/aws"
  version = "1.0.2"
  acl     = "private"

  versioning = {
    status     = false
    mfa_delete = false
  }
  lifecycle_rule = [
    {
      id                                     = "default"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7

      transition = [
        {
          days          = 90
          storage_class = "INTELLIGENT_TIERING"
        }
      ]
      noncurrent_version_transition = [
        {
          days          = 60
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 120
          storage_class = "GLACIER"
        },
      ]
      noncurrent_version_expiration = {
        days = 300
      }
    }
  ]
  bucket  = "${lower(var.application)}-${lower(var.environment)}-${each.key}-bucket"
  tags    = merge({ "IACFramework" = "Terraform" }, { "Name" = "${each.key}" }, local.tags)

}
