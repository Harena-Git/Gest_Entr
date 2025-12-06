-- Initialiser les comptes pour les personnels existants avec données de test
-- Exécuter après 03_ALTER_PERSONNEL_ADD_AUTH.sql
USE gestion_entreprise;

-- =====================================
-- DONNÉES DE TEST POUR PERSONNEL
-- =====================================
-- Mot de passe par défaut (BCrypt): "motdepasse123"
-- Hash BCrypt: $2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha

-- =====================================
-- OPTION 1: Ajouter des personnels de test complets
-- =====================================

-- D'abord, vérifier/créer les dépendances (candidat, poste, département)
-- Utiliser les IDs existants ou en créer si nécessaire

-- Exemple: insérer des candidats de test
INSERT IGNORE INTO candidat (nom, prenom, email, telephone, date_candidature, id_etat_candidat) 
VALUES 
  ('DUPONT', 'Jean', 'jean.dupont@email.com', '0601020304', '2024-01-15', 1),
  ('MARTIN', 'Marie', 'marie.martin@email.com', '0605060708', '2024-02-20', 1),
  ('BERNARD', 'Pierre', 'pierre.bernard@email.com', '0609101112', '2024-03-10', 1),
  ('THOMAS', 'Sophie', 'sophie.thomas@email.com', '0613141516', '2024-04-05', 1);

-- Exemple: ajouter des personnels avec username et password
INSERT IGNORE INTO personnel (date_embauche, actif, id_candidat, id_poste, username, password)
VALUES 
  ('2024-01-20', 1, 1, 1, 'dupont.j', 'dupont'),  -- motdepasse123
  ('2024-02-25', 1, 2, 2, 'martin.m', 'martin'),  -- motdepasse123
  ('2024-03-15', 1, 3, 3, 'bernard.p', '0123'),
  ('2024-04-10', 1, 4, 4, 'thomas.s', '4567');

-- =====================================
-- OPTION 2: Mettre à jour les personnels existants
-- =====================================
-- Décommenter et adapter selon vos IDs réels

-- UPDATE personnel SET username = 'employ.1', password = '$2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha' WHERE id_personnel = 1;
-- UPDATE personnel SET username = 'employ.2', password = '$2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha' WHERE id_personnel = 2;
-- UPDATE personnel SET username = 'employ.3', password = '$2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha' WHERE id_personnel = 3;

-- =====================================
-- VÉRIFICATION DES COMPTES CRÉÉS
-- =====================================
SELECT 
  id_personnel,
  username,
  '***' AS password_hash,
  actif,
  date_embauche,
  CONCAT(c.nom, ' ', c.prenom) AS nom_complet,
  p.libelle AS poste
FROM personnel per
LEFT JOIN candidat c ON per.id_candidat = c.id_candidat
LEFT JOIN poste p ON per.id_poste = p.id_poste
WHERE per.username IS NOT NULL
ORDER BY per.id_personnel;
