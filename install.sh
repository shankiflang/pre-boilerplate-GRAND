#!/bin/sh

# Check if mkcert exists and create the SSL files
if command -v mkcert > /dev/null; 
then
    mkcert="mkcert"
elif command -v ./mkcert > /dev/null;
then 
    mkcert="./mkcert"
elif command -v ./mkcert.exe > /dev/null; 
then
    mkcert="./mkcert.exe"
else 
    echo "Please install mkcert https://github.com/FiloSottile/mkcert"
    exit 1   
fi

if [ ! -f .docker/.dev/Nginx/SSL/Directus/cert.pem ] || [ ! -f .docker/.dev/Nginx/SSL/Directus/key.pem ] 
then
    "$mkcert" -key-file .docker/.dev/Nginx/SSL/Directus/key.pem -cert-file .docker/.dev/Nginx/SSL/Directus/cert.pem admin.localhost
fi
if [ ! -f .docker/.dev/Nginx/SSL/React/cert.pem ] || [ ! -f .docker/.dev/Nginx/SSL/React/key.pem ] 
then
    "$mkcert" -key-file .docker/.dev/Nginx/SSL/React/key.pem -cert-file .docker/.dev/Nginx/SSL/React/cert.pem localhost
fi

# Check if docker exists
if ! type "docker" > /dev/null; 
then
    echo "Please install docker"
    exit 1
fi

# Check if docker-compose exists
if ! type "docker-compose" > /dev/null; 
then
    echo "Please install docker-compose"
    exit 1
fi

# Install react dependencies
docker-compose run --rm react yarn

# Start the database and seed the database for Directus
docker-compose run --rm directus npx directus bootstrap

# Import the snapshot storted in the `snapshot.json` file
docker-compose run --rm directus npx directus schema apply --yes //directus//snapshots//snapshot.yaml

# Docker up everything
docker compose up -d --build --force-recreate