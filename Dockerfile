FROM node:16 AS builder

WORKDIR /app

COPY ./package*.json ./

# Dependances
RUN npm install


# copies des fichiers sources
COPY . .

RUN npm run build

FROM nginx:latest

WORKDIR /usr/share/nginx/html

RUN rm -f ./usr/share/nginx/html/*

COPY --from=builder /app/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf

# Ouverture sur port 80

EXPOSE 80

CMD ["nginx","-g", "daemon off;"]