#!/bin/bash

# the following variables come from CodeBuild env variable bindings
#DOCKER_REPOSITORY_NAME=""
#DOCKER_REGISTRY_REGION=""
#DOCKER_REGISTRY_URL=""

# Docker tags' variables
#DOCKER_ENV_TAG=""
#DOCKER_PREV_ENV_TAG=""
DOCKER_LATEST_TAG="latest"
DOCKER_TIME_TAG="$(date +%s)"
DOCKER_COMMIT_TAG=$(echo "$CODEBUILD_RESOLVED_SOURCE_VERSION" | cut -c 1-7)

# DRY
IMAGE_DEF_FILE_NAME="image-def.json"

# Login in AWS container registry with your AWS credentials
aws ecr get-login-password --region "${DOCKER_REGISTRY_REGION:-$AWS_REGION}" | docker login --username AWS --password-stdin "$DOCKER_REGISTRY_URL"

# re-Tag Docker image
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_PREV_ENV_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_ENV_TAG"
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_PREV_ENV_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_TIME_TAG"
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_PREV_ENV_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_COMMIT_TAG"

if [ -n "$ADD_DOCKER_LATEST_TAG" ]; then
  docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_PREV_ENV_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_LATEST_TAG"
fi

# Push/Publish Docker image
docker push "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME"

# Generate Docker image definition for CloudFormation
printf '{"Image":"%s"}' "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"${DOCKER_COMMIT_TAG:-$DOCKER_TIME_TAG}" > $IMAGE_DEF_FILE_NAME
