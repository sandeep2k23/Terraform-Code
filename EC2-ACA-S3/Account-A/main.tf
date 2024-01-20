locals {
  tags = { ProjectName = var.project_name
    ProjectMaker  = var.project_maker
    MakerEmail    = var.contact_email
    IAC_Framework = var.iac_framework
    Account       = var.account_name
  }
}

########### IAM Policy##############

resource "aws_iam_policy" "sc_ec2_policy" {
  name        = "ScEc2Policy"
  description = "An ec2 role IAM policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::<AccountB ID>:role/ScS3Role"
        }
      ]
  })
  tags = local.tags
}


################ IAM Role######################33

resource "aws_iam_role" "sc_ec2_role" {
  name = "ScEc2Role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
  tags = local.tags
}

############IAM Role Policy Attachment############
resource "aws_iam_role_policy_attachment" "sc_ec2_attachment" {
  policy_arn = aws_iam_policy.sc_ec2_policy.arn
  role       = aws_iam_role.sc_ec2_role.name
}

############## IAM Instance Profile###########
resource "aws_iam_instance_profile" "sc_ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.sc_ec2_role.name
}


############# EC2 ###################

resource "aws_instance" "sc_ec2" {
  ami                  = "ami-0005e0cfe09cc9050"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.sc_ec2_instance_profile.name
  tags                 = local.tags
}
