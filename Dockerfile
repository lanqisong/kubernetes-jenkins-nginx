FROM 127.0.0.1:5000/library/nginx:latest

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
