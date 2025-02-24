FROM node:16 AS builder

WORKDIR /app

COPY ./package*.json ./

# Dependances
RUN npm install

RUN npm run build

# copies des fichiers sources
COPY . .

FROM nginx:latest

WORKDIR /usr/share/nginx/html

RUN rm -f ./usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf

# Ouverture sur port 80

EXPOSE 80

CMD ["nginx","-g", "daemon off;"]