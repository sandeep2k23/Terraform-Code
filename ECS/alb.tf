module "alb" {

  source = "https://github.com/sandeep2k23/Terraform/blob/ECR/alb-nlb.tf"
  version = "1.0.0"
  # Use lb_custom_name only if you want to create more than one load balancer per application and environment
  #lb_custom_name     = "test" 
  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.network_subnet_ids
  security_groups    = var.security_group_ids


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.ssl_cert_arn
      target_group_index = 1
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      actions  = [{
        type             = "forward"
        target_group_index = 1
        }]
      conditions  = [{
        path_patterns = ["/identity/*"]
      }]
    },
    {
      https_listener_index = 0
      actions  = [{
        type             = "forward"
        target_group_index = 2
        }]
      conditions  = [{
        path_patterns = ["/product/*"]
      }]
    },
    {
      https_listener_index = 0
      actions  = [{
        type             = "forward"
        target_group_index = 3
        }]
      conditions  = [{
        path_patterns = ["/studies/*"]
      }]
    },
    {
      https_listener_index = 0
      actions  = [{
        type             = "forward"
        target_group_index = 0
        }]
      conditions  = [{
        path_patterns = ["/*"]
      }]
    }

  ]

  target_groups = [
    {
      tg_custom_name       = "identity"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/identity/health"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      tg_custom_name       = "product"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/product/health"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      tg_custom_name       = "studies"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/studies/health"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      tg_custom_name       = "webportal"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
  ]

  tags = local.tags
}
