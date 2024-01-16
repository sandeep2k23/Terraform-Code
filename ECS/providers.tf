locals {
  tags = {
    Name             = var.application
    BusinessFunction = var.business_function
    OwnerEmail       = var.owner_email
    ContactEmail     = var.contact_email
    Platform         = var.platform
    CostCenter       = var.cost_center
    Application      = var.application
    Purpose          = var.purpose
    Environment      = var.environment
    CreatedByEmail   = var.created_by_email
    ProjectIONumber  = var.ProjectIONumber
    IACFramework     = var.IACFramework
  }
}
