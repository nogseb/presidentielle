-- =====================================================================
-- Repères 2027 · journal automatique des modifications (FACULTATIF)
--
-- Enregistre dans la table journal chaque ajout, modification ou
-- suppression faite sur les tables éditoriales, y compris depuis
-- phpMyAdmin. À importer après le schéma.
--
-- Sur un hébergement mutualisé, la création de déclencheurs peut être
-- refusée (privilège TRIGGER ou SUPER manquant). Dans ce cas, ne rien
-- faire : la table publication garde la trace de chaque mise en ligne,
-- et le back-office PHP prévu en V2 écrira lui-même dans le journal.
-- =====================================================================

DELIMITER $$

CREATE TRIGGER trg_proposition_ai AFTER INSERT ON proposition FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, apres, auteur)
  VALUES ('proposition', NEW.code, 'insert',
          CONCAT_WS(' | ', NEW.etat, NEW.intitule, CONCAT('source ', NEW.source_id)), CURRENT_USER());
END$$

CREATE TRIGGER trg_proposition_au AFTER UPDATE ON proposition FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, avant, apres, auteur)
  VALUES ('proposition', NEW.code, 'update',
          CONCAT_WS(' | ', OLD.etat, OLD.intitule, CONCAT('source ', OLD.source_id)),
          CONCAT_WS(' | ', NEW.etat, NEW.intitule, CONCAT('source ', NEW.source_id)), CURRENT_USER());
END$$

CREATE TRIGGER trg_proposition_ad AFTER DELETE ON proposition FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, avant, auteur)
  VALUES ('proposition', OLD.code, 'delete', CONCAT_WS(' | ', OLD.etat, OLD.intitule), CURRENT_USER());
END$$

CREATE TRIGGER trg_position_au AFTER UPDATE ON position_candidat FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, avant, apres, auteur)
  VALUES ('position_candidat', CONCAT(NEW.candidat_id, '-', NEW.variable_id), 'update',
          CONCAT_WS(' | ', OLD.etat, OLD.valeur_num, OLD.modalite_id, OLD.non_aborde, CONCAT('source ', OLD.source_id)),
          CONCAT_WS(' | ', NEW.etat, NEW.valeur_num, NEW.modalite_id, NEW.non_aborde, CONCAT('source ', NEW.source_id)), CURRENT_USER());
END$$

CREATE TRIGGER trg_correspondance_au AFTER UPDATE ON correspondance FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, avant, apres, auteur)
  VALUES ('correspondance', CONCAT(NEW.candidat_id, '-', NEW.chantier_id), 'update',
          CONCAT_WS(' | ', OLD.etat, OLD.etat_chantier, CONCAT('source ', OLD.source_id)),
          CONCAT_WS(' | ', NEW.etat, NEW.etat_chantier, CONCAT('source ', NEW.source_id)), CURRENT_USER());
END$$

CREATE TRIGGER trg_candidat_au AFTER UPDATE ON candidat FOR EACH ROW
BEGIN
  INSERT INTO journal (table_nom, ligne_cle, action, avant, apres, auteur)
  VALUES ('candidat', NEW.slug, 'update',
          CONCAT_WS(' | ', OLD.statut, OLD.niveau, OLD.parti),
          CONCAT_WS(' | ', NEW.statut, NEW.niveau, NEW.parti), CURRENT_USER());
END$$

DELIMITER ;
