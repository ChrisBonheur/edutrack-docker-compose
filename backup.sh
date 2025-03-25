#!/bin/bash

# Configuration
DB_CONTAINER="postgres_db"   # Nom du conteneur PostgreSQL
DB_USER="c2513633c_bonheur"  # Nom de l'utilisateur PostgreSQL
BACKUP_DIR="/backups"       # Répertoire local des sauvegardes
DAYS_TO_KEEP=7               # Nombre de jours de rétention
S3_BUCKET="s3://edutrack-backups"  # Remplace par ton propre bucket AWS

# Création du dossier backup s'il n'existe pas
mkdir -p $BACKUP_DIR


# Liste des bases de données (excluant les bases système)
DATABASES=$(docker exec -i $DB_CONTAINER psql -U $DB_USER -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

for DB in $DATABASES; do
    TIMESTAMP=$(date +%F_%H-%M-%S)
    BACKUP_FILE="$BACKUP_DIR/${DB}_backup-$TIMESTAMP.sql"
    echo "📂 Sauvegarde de la base : $DB"
    docker exec -i $DB_CONTAINER pg_dump -U $DB_USER -d $DB > $BACKUP_FILE
done

# Nettoyage des anciennes sauvegardes
find $BACKUP_DIR -type f -name "*.sql" -mtime +$DAYS_TO_KEEP -exec rm {} \;


# Upload vers AWS S3 (si configuré)
if command -v aws &> /dev/null; then
    aws s3 cp $BACKUP_FILE $S3_BUCKET/
    echo "☁️ [$(date)] Sauvegarde envoyée sur AWS S3 ($S3_BUCKET)"
else
    echo "⚠️ [$(date)] AWS CLI non installé, upload ignoré."
fi

echo "🚀 [$(date)] Processus de sauvegarde terminé."

