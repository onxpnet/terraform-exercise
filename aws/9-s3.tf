resource "aws_s3_bucket" "onxp-bucket" {
  bucket = "bucket-name"

  tags = {
    Name        = "OnXP Bucket"
    Environment = "Production"
  }
}