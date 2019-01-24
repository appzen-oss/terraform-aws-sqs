provider "aws" {
  profile                     = "appzen-admin"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true

  assume_role {
    role_arn = "arn:aws:iam::186266557194:role/OrganizationAccountAccessRole"
  }
}
