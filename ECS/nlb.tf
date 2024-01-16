##################################################################
# Internal Network Load Balancer < Target - ALB >
##################################################################
module "nlb" {
  source             = "https://github.com/sandeep2k23/Terraform/blob/ECR/alb-nlb.tf"
  version = "1.0.0"
  # Use lb_custom_name only if you want to create more than one load balancer per application and environment
  #lb_custom_name     = "test"
  internal           = true
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnets            = var.network_subnet_ids

  depends_on = [module.alb]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 1
    }
  ]

  target_groups = [
    {

      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "alb"
      targets = {
        alb = {
          target_id = module.alb.lb_id
          port      = 80
        }
      }
    },
    {

      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "alb"
      targets = {
        alb = {
          target_id = module.alb.lb_id
          port      = 443
        }
      }
    },
    
  ]

  tags = local.tags
  
}

data "dns_a_record_set" "int_nlb_ips" {
  host = module.nlb.lb_dns_name
}

##################################################################
# External Network Load Balancer <Target - int NLB IPs>
##################################################################
module "nlb_pub" {
  source             = "app.terraform.io/syngenta-tfc/alb-nlb/aws"
  version = "1.0.0"
  # Use lb_custom_name only if you want to create more than one load balancer per application and environment
  #lb_custom_name     = "test"
  load_balancer_type = "network"
  internal           = false
  vpc_id             = var.secure_edge_vpc_id
  subnets            = var.secure_edge_subnet_ids

  
  #  TCP_UDP, UDP, TCP
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  #TLS
  https_listeners = [
   {
     port               = 443
     protocol           = "TLS"
     certificate_arn    = var.ssl_cert_arn
     target_group_index = 1
   },
  ]

  target_groups = [
    {

      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "ip"
      targets = {
        ip1 = {
          availability_zone = "all"
          target_id = data.dns_a_record_set.int_nlb_ips.addrs[0]
          port      = 80
        },
        ip2 = {
          availability_zone = "all"
          target_id = data.dns_a_record_set.int_nlb_ips.addrs[1]
          port      = 80
        }
      }
    },
    {

      backend_protocol     = "TLS"
      backend_port         = 443
      target_type          = "ip"
      targets = {
        ip1 = {
          availability_zone = "all"
          target_id = data.dns_a_record_set.int_nlb_ips.addrs[0]
          port      = 443
        },
        ip2 = {
          availability_zone = "all"
          target_id = data.dns_a_record_set.int_nlb_ips.addrs[1]
          port      = 443
        }
      }
    }
    
  ]

  tags = local.tags
  
}