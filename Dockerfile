# Stage 1
FROM node:lts-alpine as build
RUN apk add --no-cache tzdata
ENV TZ=Europe/Berlin
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build

# Stage 2
FROM nginx:stable-alpine
COPY --from=build /usr/src/app/default.conf /etc/nginx/conf.d/default.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80