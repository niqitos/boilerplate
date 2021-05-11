# REPOSITORY ARGS:
ARG BASE_IMAGES_REGISTRY=""
ARG BASE_IMAGES_REPOSITORY="images"
ARG NODE_ALPINE_IMAGE="node-14.16.1-alpine"

# ARGS-ENV mapings:
#ARG ENV_VAR="defaultValue"
#ENV ENV_VAR=$ENV_VAR

# Base
FROM $BASE_IMAGES_ECR_REGISTRY/$BASE_IMAGES_REPOSITORY:$NODE_ALPINE_IMAGE AS base

RUN apk add --update && \
    rm -rf /var/lib/apt/lists/*

# Build
FROM base AS build

WORKDIR /app

# Dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn install

# Build
COPY . .
RUN yarn build

# Application
FROM base AS application

COPY --from=build /app/package.json ./
COPY --from=build /app/yarn.lock ./
RUN yarn install --production=true && yarn global add pm2

COPY --from=build /app/.nuxt ./.nuxt

USER node
ENV PORT=8080
EXPOSE 8080

CMD [ "pm2-runtime", ".nuxt/server.js" ]
