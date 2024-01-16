module "ecr" {
    for_each = var.repositories
    source = "https://github.com/sandeep2k23/Terraform/blob/ECR/main.tf"
    version = "1.0.0"

    repository_name = "${each.key}"
    tags    = local.tags
    repository_image_scan_on_push = true
    repository_image_tag_mutability = "MUTABLE" 
}