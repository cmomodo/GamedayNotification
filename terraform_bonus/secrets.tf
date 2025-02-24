resource "aws_kms_key" "nba_secret_key" {
  description = "KMS key for NBA API secret encryption"
  enable_key_rotation = true
}

resource "aws_secretsmanager_secret" "nba_game" {
  name = "nba_game"
  description = "NBA game secret API Key for NBA API"
  kms_key_id = aws_kms_key.nba_secret_key.id


}