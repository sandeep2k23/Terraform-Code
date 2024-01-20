locals {
  tags = { ProjectName = var.project_name
    ProjectMaker  = var.project_maker
    MakerEmail    = var.contact_email
    IAC_Framework = var.iac_framework
    Account       = var.account_name
  }
}

############## S3 Bucket #######################

resource "aws_s3_bucket" "sc_s3_bucker" {
  bucket = "sc-ec2-connect-s3"
  tags = local.tags
}

############### IAM Policy ################

resource "aws_iam_policy" "sc_s3_policy" {
  name        = "ScEc2Policy"
  description = "An ec2 role IAM policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:*",
            "s3-object-lambda:*"
          ],
          "Resource" : "*"
        }
      ]
  })
  tags = local.tags
}


################ IAM Role######################33

resource "aws_iam_role" "sc_s3_role" {
  name = "ScS3Role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Statement1",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::<AccountA ID>:<Account Name>"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
  tags = local.tags
}

############IAM Role Policy Attachment############
resource "aws_iam_role_policy_attachment" "sc_s3_attachment" {
  policy_arn = aws_iam_policy.sc_s3_policy.arn
  role       = aws_iam_role.sc_s3_role.name
}
