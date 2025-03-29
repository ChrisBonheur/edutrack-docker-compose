@echo off
echo Vérification de Docker...
docker --version || (
    echo Docker n'est pas installé. 
    echo Veuillez l'installer depuis: https://www.docker.com/products/docker-desktop
    pause
    exit
)

echo Lancement de l'application...
docker-compose -f app down
docker-compose -f app pull
docker-compose -f app up -d
start http://localhost:4300
echo L'application est ouverte dans votre navigateur!
pause