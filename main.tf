/* provider aws */
provider "aws" {
  region = "eu-west-1"
}

/* create s3 bucket, WEB, public read, index.html default */
resource "aws_s3_bucket" "web" {
  bucket = var.s3_name
  acl = "public-read"
}
/* resource aws_s3_bucket_website_configuration */
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id
  error_document = var.error_name
  index_document = var.index_name
}