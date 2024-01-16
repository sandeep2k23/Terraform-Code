environment = "Stage"
task_exec_role = "arn:aws:iam::xxxxxxxxxxx:role/Weatherturfapp-ECS-TaskExecution-Role"
ecs_subnets = [
    "subnet-082d1791cbb76fa6d",
    "subnet-0032b1268e3d2a8cd",
  ]
ecs_security_groups = ["sg-00027122eceb72f5e"]
vpc_id = "vpc-084001a9c172ceb51"
network_subnet_ids = ["subnet-01536480435cd9171", "subnet-0a9f414e57a6a7e0e"]
secure_edge_vpc_id = "vpc-06057a570e6f69fe1"
secure_edge_subnet_ids = ["subnet-08ca25557513822e3", "subnet-0ec9c79d28ae370d9"]
security_group_ids = ["sg-0e6d26e89673e3944", "sg-00027122eceb72f5e"]
ssl_cert_arn = "arn:aws:acm:eu-central-1:517826409102:certificate/e928b543-c5b9-4d5a-92e8-588a324a5c21"
database_security_group_ids = ["sg-022806c97ca802dff", "sg-05b5d483536589919","sg-00027122eceb72f5e","sg-0b749e7caac56c469"]
database_subnet_group = "stack-t4nrpxyio7ifbv7on-rdssubnetgroup-gns9llibytur"

secrets = {
    "identity" = {
      #Server=deawdposscis1.cq9pf63svjga.eu-central-1.rds.amazonaws.com;Database=starsstage;Port=5432
      name = "identity"
      secret_name = "/identity"
      secret_string = <<EOT
      {
    "RecipeDatabaseConfiguration": {
      "RecipeDatabaseConnectionString": "Server=deawdposscis1.cq9pf63svjga.eu-central-1.rds.amazonaws.com;Database=starsstage;Port=5432;User Id=possusradmin;Password=Syn@possusradmin~456;"
    },
    "TokenConfiguration": {
      "Secret": "@[C8*B48~Bpw7vvZ",
      "Issuer": "sandeep",
      "Audience": "sandeep",
      "Expires": 1440
    },
    "SamlConfiguration": {
      "LocalServiceProviderConfiguration": {
        "Name": "recipe-database",
        "Description": "Example Service Provider",
        "AssertionConsumerServiceUrl": "https://stars.sandeep.digitalsoftminds.eu/Saml/AssertionConsumerService",
        "SingleLogoutServiceUrl": "http://stars.sandeep.digitalsoftminds.eu/SAML/SingleLogoutService",
        "ArtifactResolutionServiceUrl": "http://stars.sandeep.digitalsoftminds.eu/SAML/ArtifactResolutionService",
        "LocalCertificates": [
          {
            "FileName": "Certificates/sp.pfx",
            "Password": "password"
          }
        ]
      },
      "PartnerIdentityProviderConfigurations": [
        {
          "Name": "https://sts.windows.net/b228e5b0-e9d6-427f-a7c7-b219b9915411/",
          "Description": "Azure AD",
          "SignLogoutRequest": true,
          "SignLogoutResponse": true,
          "SingleSignOnServiceUrl": "https://login.microsoftonline.com/b228e5b0-e9d6-427f-a7c7-b219b9915411/saml2",
          "SingleLogoutServiceUrl": "https://login.microsoftonline.com/b228e5b0-e9d6-427f-a7c7-b219b9915411/saml2",
          "PartnerCertificates": [
            {
              "FileName": "Certificates/azure.cer"
            }
          ]
        }
      ]
    },
    "PartnerName": "https://sts.windows.net/b228e5b0-e9d6-427f-a7c7-b219b9915411/"
  }
  EOT
    },
    "product" = {
      name = "product"
      secret_name = "/product"
      secret_string = <<EOT
      {
      "RecipeDatabaseConfiguration": {
        "RecipeDatabaseConnectionString": "Server=deawdposscis1.cq9pf63svjga.eu-central-1.rds.amazonaws.com;Database=starsstage;Port=5432;User Id=possusradmin;Password=Syn@possusradmin~456;",
        "InternalProductPrefix": "IP"
      },
      "TokenConfiguration": {
        "Secret": "@[C8*B48~Bpw7vvZ",
        "Issuer": "sandeep",
        "Audience": "sandeep",
        "Expires": 1440
      },
      "SamlConfiguration": {
            "LocalServiceProviderConfiguration": {
              "Name": "recipe-database",
              "Description": "Example Service Provider",
              "AssertionConsumerServiceUrl": "https://stars.sandeep.digitalsoftminds.eu/Saml/AssertionConsumerService",
              "SingleLogoutServiceUrl": "https://stars.sandeep.digitalsoftminds.eu/SAML/SingleLogoutService",
              "ArtifactResolutionServiceUrl": "https://stars.sandeep.digitalsoftminds.eu/SAML/ArtifactResolutionService",
              "LocalCertificates": [
                {
                  "FileName": "Certificates/sp.pfx",
                  "Password": "password"
                }
              ]
            },
        "PartnerIdentityProviderConfigurations": [
          {
            "Name": "https://sts.windows.net/b228e5b0-e9d6-427f-a7c7-b219b9915411/",
            "Description": "Azure AD",
            "SignLogoutRequest": true,
            "SignLogoutResponse": true,
            "SingleSignOnServiceUrl": "https://login.microsoftonline.com/b228e5b0-e9d6-427f-a7c7-b219b9915411/saml2",
            "SingleLogoutServiceUrl": "https://login.microsoftonline.com/b228e5b0-e9d6-427f-a7c7-b219b9915411/saml2",
            "PartnerCertificates": [
              {
                "FileName": "Certificates/azure.cer"
              }
            ]
          }
        ]
      },
      "PartnerName": "https://sts.windows.net/b228e5b0-e9d6-427f-a7c7-b219b9915411/",
      "JWT": {
        "Key": "9CuRq@*i_~x-~@]S2hgcEK=_q%7Dn2tg",
        "Issuer": "DigitalSoftMinds-sandeep"
      }
    }
    EOT
    },
    "studies" = {
      name = "studies"
      secret_name = "/studies"
      secret_string = <<EOT
      {
      "RecipeDatabaseConfiguration": {
        "RecipeDatabaseConnectionString": "Server=deawdposscis1.cq9pf63svjga.eu-central-1.rds.amazonaws.com;Database=starsstage;Port=5432;User Id=possusradmin;Password=Syn@possusradmin~456;",
        "InternalProductPrefix": "IP"
      },
      "TokenConfiguration": {
        "Secret": "@[C8*B48~Bpw7vvZ",
        "Issuer": "sandeep",
        "Audience": "sandeep",
        "Expires": 1440
      },
        "AwsS3Configuration": {
          "BucketName": "stars-stage-data-bucket",
          "AwsRegion": "eu-central-1"
        },
      "Logging": {
        "LogLevel": {
          "Default": "Debug",
          "Microsoft": "Debug",
          "Microsoft.Hosting.Lifetime": "Debug"
        }
      }
    }
    EOT
    }
}
  
