#!/bin/sh

docker pull ghcr.io/hamahama-dev/pupmory/pupmory-backend:latest

docker ps --filter "name=pupmory-backend"

# process stop & remove regardless of ps result because:
# if docker demon has restarted, there's no running container but stopped container still exists
docker stop pupmory-backend || true && docker rm pupmory-backend || true

# replace curly brackets with your values
docker run \
  --name pupmory-backend \
  -p 8080:8080 \
  -e DB_URL={} \
  -e DB_USERNAME={} \
  -e DB_PASSWORD={} \
  -e MAIL_USERNAME={} \
  -e MAIL_PASSWORD={} \
  -e GPT_KEY={} \
  -e AWS_REGION={} \
  -e S3_BUCKET={} \
  -e S3_ACCESS_KEY={} \
  -e S3_SECRET_KEY={} \
  -e JWT_SECRET={} \
  ghcr.io/hamahama-dev/pupmory/pupmory-backend