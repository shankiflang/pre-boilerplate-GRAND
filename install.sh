#!/bin/sh

# Check if mkcert exists and create the SSL files
if ! type "mkcert" > /dev/null; 
then
    echo "Please install mkcert https://github.com/FiloSottile/mkcert"
    exit 1
else 
    if [ ! -f .docker/.dev/Nginx/SSL/Directus/cert.pem ] || [ ! -f .docker/.dev/Nginx/SSL/Directus/key.pem ] 
    then
        mkcert -key-file .docker/.dev/Nginx/SSL/Directus/key.pem -cert-file .docker/.dev/Nginx/SSL/Directus/cert.pem admin.localhost
    fi
    if [ ! -f .docker/.dev/Nginx/SSL/React/cert.pem ] || [ ! -f .docker/.dev/Nginx/SSL/React/key.pem ] 
    then
        mkcert -key-file .docker/.dev/Nginx/SSL/React/key.pem -cert-file .docker/.dev/Nginx/SSL/React/cert.pem localhost
    fi
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

#Import the snapshot storted in the `snapshot.json` file
docker-compose run --rm directus npx directus schema apply --yes /directus/snapshots/snapshot.yaml

# Create an "admin" role
role_id=`echo ${docker-compose run --rm directus npx directus roles create --role admin --admin true}`

# Create an "admin" user
docker-compose run --rm directus npx directus users create --email admin@admin.com --password admin --role $role_id

# Docker up everything
docker compose up -d --build --force-recreate