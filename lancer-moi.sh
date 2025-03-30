#!/bin/bash
echo "Vérification de Docker..."
if ! command -v docker &> /dev/null; then
    echo "Veuillez installer Docker d'abord :"
    echo "sudo apt update && sudo apt install docker.io docker-compose"
    exit 1
fi

echo "Lancement de l'application..."
docker-compose down
docker-compose pull
docker-compose up --build #-d
echo "L'application est ouverte dans votre navigateur!"
