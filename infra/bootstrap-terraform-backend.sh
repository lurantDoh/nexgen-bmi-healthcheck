#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?AWS_REGION must be set}"

state_bucket="new-bmi-check-tfstate-027024089660"
lock_table="new-bmi-check-tf-locks"

if ! aws s3api head-bucket --bucket "$state_bucket" >/dev/null 2>&1; then
  if [[ "$AWS_REGION" == "us-east-1" ]]; then
    aws s3api create-bucket \
      --bucket "$state_bucket" \
      --region "$AWS_REGION"
  else
    aws s3api create-bucket \
      --bucket "$state_bucket" \
      --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION"
  fi
fi

aws s3api put-bucket-versioning \
  --bucket "$state_bucket" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "$state_bucket" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

if ! aws dynamodb describe-table --table-name "$lock_table" --region "$AWS_REGION" >/dev/null 2>&1; then
  aws dynamodb create-table \
    --table-name "$lock_table" \
    --region "$AWS_REGION" \
    --billing-mode PAY_PER_REQUEST \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH >/dev/null
fi

aws dynamodb wait table-exists --table-name "$lock_table" --region "$AWS_REGION"
