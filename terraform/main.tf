/* provider aws */
provider "aws" {
  region = "eu-west-1"
}


/* create s3 bucket, WEB, public read, index.html default */
resource "aws_s3_bucket" "web" {
  bucket = var.s3_name
}
/* resource aws_s3_bucket_website_configuration */
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id
  error_document {
    key = var.error_name
  }
  index_document {
    suffix = var.index_name
  }
}

/* resource aws_s3_bucket_acl */
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.web.id
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "prod_website" {  
  bucket = aws_s3_bucket.web.id   
policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.web.id}/*"            
          ]        
      }    
    ]
}
POLICY
}