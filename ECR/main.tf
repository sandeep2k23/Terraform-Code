locals {
  create_private_repository = var.repository_type == "private"?true : false
  create_public_repository  = var.repository_type == "public"?true : false
  environment               = lower(var.tags["Environment"])=="production" ? "prod" : (lower(var.tags["Environment"])=="development" ? "dev" : (lower(var.tags["Environment"])=="test" ? "test" : "stage"))
  repository_full_name           = "${replace(lower(var.tags["Application"])," ","")}-${lower(local.environment)}-${var.repository_name}-ecr"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}


################################################################################
# Repository
################################################################################

resource "aws_ecr_repository" "this" {
  count = local.create_private_repository ? 1 : 0

  name                 = local.repository_full_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_encryption_type=="KMS"?var.repository_kms_key : null
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = var.tags
}

################################################################################
# Repository Policy
################################################################################

resource "aws_ecr_repository_policy" "this" {
  count = local.create_private_repository && var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_policy
}

################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count = local.create_private_repository && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_lifecycle_policy
}

################################################################################
# Public Repository
################################################################################

resource "aws_ecrpublic_repository" "this" {
  count = local.create_public_repository ? 1 : 0

  repository_name = local.repository_full_name

  dynamic "catalog_data" {
    for_each = length(var.public_repository_catalog_data) > 0 ? [
      var.public_repository_catalog_data
    ] : []

    content {
      about_text        = try(catalog_data.value.about_text, null)
      architectures     = try(catalog_data.value.architectures, null)
      description       = try(catalog_data.value.description, null)
      logo_image_blob   = try(catalog_data.value.logo_image_blob, null)
      operating_systems = try(catalog_data.value.operating_systems, null)
      usage_text        = try(catalog_data.value.usage_text, null)
    }
  }
}

################################################################################
# Public Repository Policy
################################################################################

resource "aws_ecrpublic_repository_policy" "example" {
  count = local.create_public_repository ? 1 : 0

  repository_name = aws_ecrpublic_repository.this[0].repository_name
  policy          = var.repository_policy
}

################################################################################
# Registry Policy
################################################################################

resource "aws_ecr_registry_policy" "this" {
  count = var.create_registry_policy ? 1 : 0
  policy = var.registry_policy
}


################################################################################
# Registry Scanning Configuration
################################################################################

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.manage_registry_scanning_configuration ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules

    content {
      scan_frequency = rule.value.scan_frequency

      repository_filter {
        filter      = rule.value.filter
        filter_type = try(rule.value.filter_type, "WILDCARD")
      }
    }
  }
}

################################################################################
# Registry Replication Configuration
################################################################################

resource "aws_ecr_replication_configuration" "this" {
  count = var.create_registry_replication_configuration ? 1 : 0

  replication_configuration {

    dynamic "rule" {
      for_each = var.registry_replication_rules

      content {
        dynamic "destination" {
          for_each = rule.value.destinations

          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }

        dynamic "repository_filter" {
          for_each = try(rule.value.repository_filters, [])

          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}
