FROM node:16-slim AS runtime

###############################################################################

FROM runtime AS vendors

ARG BUILD_ENV=prod

WORKDIR /srv/app
RUN mkdir /srv/app/node_modules
COPY package.json yarn.lock ./

RUN if [ "$BUILD_ENV" = "prod" ]; then export YARN_ARGS=--prod; fi; \
    yarn install \
        --frozen-lockfile \
        --no-progress \
        --non-interactive \
        ${YARN_ARGS}

###############################################################################

FROM runtime AS builder

ARG REACT_APP_API_BASEURL=http://localhost:8080

WORKDIR /srv/app

COPY . .
COPY --from=vendors /srv/app/node_modules node_modules

RUN yarn build

###############################################################################

FROM runtime AS app

WORKDIR /srv/app

RUN yarn global add serve

COPY --from=builder /srv/app/build build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
