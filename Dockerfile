FROM node:16 AS builder

WORKDIR /

COPY ./package*.json ./

RUN npm install

COPY . .

RUN npm run build  # Run next build to create production build

FROM nginx:latest

WORKDIR /usr/share/nginx/html

RUN rm -f ./*

COPY --from=builder /.next /usr/share/nginx/html/.next
COPY --from=builder /public /usr/share/nginx/html/public
COPY --from=builder /package.json /usr/share/nginx/html/package.json

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
