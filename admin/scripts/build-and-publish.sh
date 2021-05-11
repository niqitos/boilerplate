#!/bin/bash

# BASE_IMAGES_REGISTRY can be set here or through AWS CodeBuild's env variables
#BASE_IMAGES_REGISTRY=""
#BASE_IMAGES_REGISTRY_REGION=""

# the following variables come from CodeBuild env variable bindings
#DOCKER_REPOSITORY_NAME=""
#DOCKER_REGISTRY_REGION=""
#DOCKER_REGISTRY_URL=""

# Docker tags' variables
#DOCKER_ENV_TAG=""
DOCKER_TIME_TAG="$(date +%s)"
DOCKER_COMMIT_TAG=$(echo "$CODEBUILD_RESOLVED_SOURCE_VERSION" | cut -c 1-7)

# DRY
#SCRIPT_DIR=$(dirname "$0")
#PROJECT_DIR="$SCRIPT_DIR/../../"
#DOCKER_FILE_PATH="Dockerfile"
IMAGE_DEF_FILE_NAME="image-def.json"

# Login in AWS container registry with your AWS credentials
aws ecr get-login-password --region "${DOCKER_REGISTRY_REGION:-$AWS_REGION}" | docker login --username AWS --password-stdin "$DOCKER_REGISTRY_URL"

# Login in a common/base images Container Registry within other account if registry differs
if [ -n "$BASE_IMAGES_REGISTRY" ]; then
  aws ecr get-login-password --region "${BASE_IMAGES_REGISTRY_REGION:-${DOCKER_REGISTRY_REGION:-$AWS_REGION}}" | docker login --username AWS --password-stdin "$BASE_IMAGES_REGISTRY"
fi

# Build Docker image
(docker build \
  --build-arg BASE_IMAGES_REGISTRY="${BASE_IMAGES_REGISTRY:-$DOCKER_REGISTRY_URL}" \
  --build-arg BASE_IMAGES_REPOSITORY="$BASE_IMAGES_REPOSITORY" \
  --build-arg NODE_ALPINE_IMAGE="$NODE_ALPINE_IMAGE" \
  -t "$DOCKER_REPOSITORY_NAME":"$DOCKER_ENV_TAG" \
  -t "$DOCKER_REPOSITORY_NAME":"$DOCKER_TIME_TAG" \
  -t "$DOCKER_REPOSITORY_NAME":"$DOCKER_COMMIT_TAG" \
  .) || exit 1

# Tag Docker image
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_ENV_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_ENV_TAG"
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_TIME_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_TIME_TAG"
docker tag "$DOCKER_REPOSITORY_NAME":"$DOCKER_COMMIT_TAG" "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"$DOCKER_COMMIT_TAG"

# Push/Publish Docker image
docker push "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME"

# Generate Docker image definition for CloudFormation
printf '{"Image":"%s"}' "$DOCKER_REGISTRY_URL"/"$DOCKER_REPOSITORY_NAME":"${DOCKER_COMMIT_TAG:-$DOCKER_TIME_TAG}" > $IMAGE_DEF_FILE_NAME
