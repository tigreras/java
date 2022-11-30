FROM node:lts-alpine AS build-stage
RUN npm i -g @quasar/cli
WORKDIR /home/app
COPY . /home/app
RUN npm install
RUN npm run ${BUILD_ENV}

FROM nginx:latest
COPY --from=build-stage /home/app/mime.types /etc/nginx/mime.types
COPY --from=build-stage /home/app/nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-stage /home/app/dist/spa /etc/nginx/html
RUN chmod -R 777 /var/cache/nginx /etc/nginx/nginx.conf /run/
EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]
