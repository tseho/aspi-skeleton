FROM node:16-slim AS vendors

ARG BUILD_ENV=prod

WORKDIR /srv/app

COPY package.json yarn.lock ./

RUN yarn install \
        --frozen-lockfile \
        --no-progress \
        --non-interactive \
        --prod

###############################################################################

FROM node:16-slim AS builder

WORKDIR /srv/app

COPY --from=vendors /srv/app/node_modules node_modules
COPY public public
COPY src src
COPY package.json tsconfig.json ./

RUN yarn build

###############################################################################

FROM node:16-slim AS app

WORKDIR /srv/app

RUN yarn global add serve

COPY --from=builder /srv/app/build build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
