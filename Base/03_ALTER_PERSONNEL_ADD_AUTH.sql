-- Ajouter les colonnes username et password à la table personnel
USE gestion_entreprise;

ALTER TABLE personnel
ADD COLUMN username VARCHAR(100) NOT NULL UNIQUE,
ADD COLUMN password VARCHAR(255) NOT NULL;

-- Remarque: 
-- - username: identifiant unique pour la connexion
-- - password: mot de passe haché en BCrypt
-- Format BCrypt: $2a$10$... (ex: $2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha pour "motdepasse123")
