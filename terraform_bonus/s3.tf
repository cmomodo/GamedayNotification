resource "aws_s3_bucket" "nba_data" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "NBA Game Data Bucket"
  }
}

resource "aws_s3_bucket_policy" "nba_data_policy" {
  bucket = aws_s3_bucket.nba_data.id
  policy = data.aws_iam_policy_document.nba_data_policy.json
}

#This resource disables block public access settings for the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.nba_data.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


data "aws_iam_policy_document" "nba_data_policy" {
  statement {
    sid = "AllowGetObject"
    principals {
      type        = "AWS"
      identifiers = [var.iam_user_arn] # Replace with the actual ARN of the user or role
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.nba_data.arn}/*",
    ]
  }

  statement {
    sid = "AllowPutObject"
    principals {
      type        = "AWS"
      identifiers = [var.iam_user_arn] # Replace with the actual ARN of the user or role
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.nba_data.arn}/*",
    ]
  }
}
