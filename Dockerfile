FROM node:alpine

EXPOSE 8080

RUN apk add git

RUN npm -g install git-cache-http-server

CMD git-cache-http-server
