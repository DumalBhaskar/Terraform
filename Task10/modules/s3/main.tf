
resource "aws_s3_bucket" "mytestbucket" {
  count = var.create_bucket ? 1 : 0

  bucket = var.bucket_name
  
}