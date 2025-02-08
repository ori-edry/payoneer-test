# Stage 1: Build the Angular app
FROM node:alpine AS build
WORKDIR /app
COPY payoneer/package.json payoneer/package-lock.json ./
RUN npm install
COPY payoneer/ ./
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY --from=build /app/dist/payoneer/browser /usr/share/nginx/html

# Create default nginx configuration for Angular
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
