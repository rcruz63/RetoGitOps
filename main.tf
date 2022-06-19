/* provider aws */
provider "aws" {
  region = "eu-west-1"
}

/* create s3 bucket, WEB, public read, index.html default */
resource "aws_s3_bucket" "web" {
  bucket = var.s3_name
  acl = "public-read"
  website {
    index_document = var.index_name
  }
}