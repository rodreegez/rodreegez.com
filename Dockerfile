FROM ruby:3.4-alpine AS build

WORKDIR /app

RUN apk add --no-cache build-base git

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bin/build

FROM nginx:1.29-alpine

WORKDIR /usr/share/nginx/html

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/ ./

EXPOSE 80
