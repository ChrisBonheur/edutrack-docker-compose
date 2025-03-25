-- Vérifie si le rôle existe déjà avant de le créer
DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'c2513633c_bonheur') THEN
      -- Crée l'utilisateur avec un mot de passe si le rôle n'existe pas
      CREATE ROLE c2513633c_bonheur WITH LOGIN PASSWORD '_^-xQX0]t9DQ';
      
      -- Donne à l'utilisateur des droits pour créer des bases de données
      ALTER ROLE c2513633c_bonheur CREATEDB;

      -- Donne à l'utilisateur des privilèges sur la base de données existante
      GRANT ALL PRIVILEGES ON DATABASE edutrack_template TO c2513633c_bonheur;

      -- Rendre l'utilisateur superutilisateur
      ALTER ROLE c2513633c_bonheur WITH SUPERUSER;
   END IF;
END
$$;
