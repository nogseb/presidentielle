-- =====================================================================
-- Repères 2027 · biographies au 17 octobre 2026
-- Gabarit : fonction actuelle, puis un ou deux jalons ; ni adjectif ni appréciation.
-- Sources : article de Wikipédia de chaque candidat (révision indiquée en date de
-- publication), date de naissance Wikidata recoupée avec l'article ; Sud Radio pour
-- Benoît Mathieu. Sans source fiable à ce jour : Selma Labib, Mira Markovic,
-- Antoine Mikolajczak (biographie à documenter).
-- À importer après database/migrations/002_biographies.sql.
-- =====================================================================

SET NAMES utf8mb4;

INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('wikipedia-arthaud-2026-10-17', 'https://fr.wikipedia.org/wiki/Nathalie_Arthaud', 'Nathalie Arthaud — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-10', 4, '2026-10-17'),
('wikipedia-asselineau-2026-10-17', 'https://fr.wikipedia.org/wiki/Fran%C3%A7ois_Asselineau', 'François Asselineau — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-12', 4, '2026-10-17'),
('wikipedia-attal-2026-10-17', 'https://fr.wikipedia.org/wiki/Gabriel_Attal', 'Gabriel Attal — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-15', 4, '2026-10-17'),
('wikipedia-batho-2026-10-17', 'https://fr.wikipedia.org/wiki/Delphine_Batho', 'Delphine Batho — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-07-29', 4, '2026-10-17'),
('wikipedia-becht-2026-10-17', 'https://fr.wikipedia.org/wiki/Olivier_Becht', 'Olivier Becht — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-10', 4, '2026-10-17'),
('wikipedia-bertrand-2026-10-17', 'https://fr.wikipedia.org/wiki/Xavier_Bertrand', 'Xavier Bertrand — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-11', 4, '2026-10-17'),
('wikipedia-bouamrane-2026-10-17', 'https://fr.wikipedia.org/wiki/Karim_Bouamrane', 'Karim Bouamrane — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-11', 4, '2026-10-17'),
('wikipedia-branco-2026-10-17', 'https://fr.wikipedia.org/wiki/Juan_Branco', 'Juan Branco — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-16', 4, '2026-10-17'),
('wikipedia-cazeneuve-2026-10-17', 'https://fr.wikipedia.org/wiki/Bernard_Cazeneuve', 'Bernard Cazeneuve — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-15', 4, '2026-10-17'),
('wikipedia-dupont-aignan-2026-10-17', 'https://fr.wikipedia.org/wiki/Nicolas_Dupont-Aignan', 'Nicolas Dupont-Aignan — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-10', 4, '2026-10-17'),
('wikipedia-egger-2026-10-17', 'https://fr.wikipedia.org/wiki/Clara_Egger', 'Clara Egger — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-09-03', 4, '2026-10-17'),
('wikipedia-glucksmann-2026-10-17', 'https://fr.wikipedia.org/wiki/Rapha%C3%ABl_Glucksmann', 'Raphaël Glucksmann — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-16', 4, '2026-10-17'),
('wikipedia-kazib-2026-10-17', 'https://fr.wikipedia.org/wiki/Anasse_Kazib', 'Anasse Kazib — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17'),
('wikipedia-lalanne-2026-10-17', 'https://fr.wikipedia.org/wiki/Francis_Lalanne', 'Francis Lalanne — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17'),
('wikipedia-le-pen-2026-10-17', 'https://fr.wikipedia.org/wiki/Marine_Le_Pen', 'Marine Le Pen — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-13', 4, '2026-10-17'),
('wikipedia-lisnard-2026-10-17', 'https://fr.wikipedia.org/wiki/David_Lisnard', 'David Lisnard — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17'),
('wikipedia-massard-2026-10-17', 'https://fr.wikipedia.org/wiki/Lydie_Massard', 'Lydie Massard — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-09-19', 4, '2026-10-17'),
('sudradio-2026-05-06-mathieu', 'https://www.sudradio.fr/sud-radio/presidentielle-2027-un-professeur-sillonne-la-france-a-velo-en-quete-des-500-parrainages', 'Présidentielle 2027 : un professeur sillonne la France à vélo en quête des 500 parrainages', 'Sud Radio', 'Sud Radio', '2026-05-06', 3, '2026-10-17'),
('wikipedia-melenchon-2026-10-17', 'https://fr.wikipedia.org/wiki/Jean-Luc_M%C3%A9lenchon', 'Jean-Luc Mélenchon — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-12', 4, '2026-10-17'),
('wikipedia-philippe-2026-10-17', 'https://fr.wikipedia.org/wiki/%C3%89douard_Philippe', 'Édouard Philippe — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17'),
('wikipedia-philippot-2026-10-17', 'https://fr.wikipedia.org/wiki/Florian_Philippot', 'Florian Philippot — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-10', 4, '2026-10-17'),
('wikipedia-polony-2026-10-17', 'https://fr.wikipedia.org/wiki/Natacha_Polony', 'Natacha Polony — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17'),
('wikipedia-retailleau-2026-10-17', 'https://fr.wikipedia.org/wiki/Bruno_Retailleau', 'Bruno Retailleau — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-16', 4, '2026-10-17'),
('wikipedia-roussel-2026-10-17', 'https://fr.wikipedia.org/wiki/Fabien_Roussel', 'Fabien Roussel — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-10', 4, '2026-10-17'),
('wikipedia-ruffin-2026-10-17', 'https://fr.wikipedia.org/wiki/Fran%C3%A7ois_Ruffin', 'François Ruffin — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-09-26', 4, '2026-10-17'),
('wikipedia-tondelier-2026-10-17', 'https://fr.wikipedia.org/wiki/Marine_Tondelier', 'Marine Tondelier — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-12', 4, '2026-10-17'),
('wikipedia-zemmour-2026-10-17', 'https://fr.wikipedia.org/wiki/%C3%89ric_Zemmour', 'Éric Zemmour — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-10-17', 4, '2026-10-17');

UPDATE candidat SET bio = 'Porte-parole de Lutte ouvrière depuis 2008, enseignante. Ancienne conseillère municipale de Vaulx-en-Velin, candidate à l''élection présidentielle en 2012, 2017 et 2022.',
  date_naissance = '1970-02-23',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-arthaud-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'arthaud';

UPDATE candidat SET bio = 'Fondateur en 2007 de l''Union populaire républicaine. Ancien inspecteur des finances, conseiller de Paris de 2001 à 2008, candidat à l''élection présidentielle de 2017.',
  date_naissance = '1957-09-14',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-asselineau-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'asselineau';

UPDATE candidat SET bio = 'Député des Hauts-de-Seine, président du groupe Ensemble pour la République à l''Assemblée nationale et secrétaire général de Renaissance. Premier ministre de janvier à septembre 2024.',
  date_naissance = '1989-03-16',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-attal-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'attal';

UPDATE candidat SET bio = 'Députée des Deux-Sèvres et présidente de Génération écologie depuis 2018. Ministre de l''Écologie de 2012 à 2013, candidate à la primaire écologiste de 2021.',
  date_naissance = '1973-03-23',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-batho-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'batho';

UPDATE candidat SET bio = 'Député du Haut-Rhin, ancien maire de Rixheim. Ministre délégué chargé du Commerce extérieur et des Français de l''étranger de 2022 à 2024.',
  date_naissance = '1976-04-28',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-becht-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'becht';

UPDATE candidat SET bio = 'Président du conseil régional des Hauts-de-France depuis 2016. Ministre de la Santé puis du Travail entre 2005 et 2012, secrétaire général de l''UMP de 2008 à 2010.',
  date_naissance = '1965-03-21',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-bertrand-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'bertrand';

UPDATE candidat SET bio = 'Maire de Saint-Ouen-sur-Seine depuis 2020, réélu en 2026, et conseiller départemental de la Seine-Saint-Denis. Chef d''entreprise, membre du Parti socialiste depuis 2014.',
  date_naissance = '1973-02-21',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-bouamrane-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'bouamrane';

UPDATE candidat SET bio = 'Avocat, essayiste et réalisateur, docteur en droit. Ancien conseiller juridique de WikiLeaks et de Julian Assange en France, auteur de Crépuscule (2019).',
  date_naissance = '1989-08-26',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-branco-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'branco';

UPDATE candidat SET bio = 'Fondateur en 2023 du mouvement La Convention, avocat. Premier ministre de décembre 2016 à mai 2017, ministre de l''Intérieur de 2014 à 2016.',
  date_naissance = '1963-06-02',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-cazeneuve-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'cazeneuve';

UPDATE candidat SET bio = 'Président de Debout la France et maire d''Yerres depuis 2026, fonction déjà exercée de 1995 à 2017. Député de l''Essonne de 1997 à 2024, candidat à l''élection présidentielle en 2012, 2017 et 2022.',
  date_naissance = '1961-03-07',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-dupont-aignan-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'dupont-aignan';

UPDATE candidat SET bio = 'Politologue, enseignante-chercheuse en relations internationales. Candidate en 2022 pour le collectif Espoir RIC, à l''origine du parti Solution démocratique fondé en 2024.',
  date_naissance = '1988-01-02',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-egger-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'egger';

UPDATE candidat SET bio = 'Député européen depuis 2019 et cofondateur de Place publique en 2018. Ancien réalisateur de documentaires et essayiste, conseiller du président géorgien de 2009 à 2012.',
  date_naissance = '1979-10-15',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-glucksmann-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'glucksmann';

UPDATE candidat SET bio = 'Cheminot et syndicaliste SUD-Rail, membre de Révolution permanente depuis 2017. Avait tenté de se présenter à l''élection présidentielle de 2022.',
  date_naissance = NULL,
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-kazib-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'kazib';

UPDATE candidat SET bio = 'Auteur-compositeur-interprète, acteur et écrivain, connu depuis 1986 pour la chanson On se retrouvera. Candidat sur la liste « France libre » aux élections européennes de 2024.',
  date_naissance = '1958-08-08',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-lalanne-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'lalanne';

UPDATE candidat SET bio = 'Députée du Pas-de-Calais depuis 2017 et présidente du groupe Rassemblement national à l''Assemblée nationale. Présidente du FN, devenu RN, de 2011 à 2021, candidate à l''élection présidentielle en 2012, 2017 et 2022.',
  date_naissance = '1968-08-05',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-le-pen-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'le-pen';

UPDATE candidat SET bio = 'Maire de Cannes depuis 2014 et président de l''Association des maires de France. Fondateur de Nouvelle Énergie, il a quitté en 2026 Les Républicains, dont il était vice-président.',
  date_naissance = '1969-02-02',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-lisnard-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'lisnard';

UPDATE candidat SET bio = 'Membre de l''Union démocratique bretonne, députée européenne de 2023 à 2024.',
  date_naissance = '1978-08-24',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-massard-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'massard';

UPDATE candidat SET bio = 'Enseignant, ingénieur en agroalimentaire de formation. Candidat indépendant et sans parti, il parcourt la France à vélo pour réunir les 500 parrainages.',
  date_naissance = NULL,
  bio_source_id = (SELECT id FROM source WHERE cle = 'sudradio-2026-05-06-mathieu'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'mathieu';

UPDATE candidat SET bio = 'Fondateur de La France insoumise en 2016, sans mandat électif depuis 2022. Ancien sénateur, ministre délégué de 2000 à 2002, député européen puis député, candidat à l''élection présidentielle en 2012, 2017 et 2022.',
  date_naissance = '1951-08-19',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-melenchon-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'melenchon';

UPDATE candidat SET bio = 'Maire du Havre et président d''Horizons, parti qu''il a fondé en 2021. Premier ministre de mai 2017 à juillet 2020.',
  date_naissance = '1970-11-28',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-philippe-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'philippe';

UPDATE candidat SET bio = 'Président des Patriotes, parti qu''il a fondé en 2017. Ancien vice-président du Front national, député européen de 2014 à 2019.',
  date_naissance = '1981-10-24',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-philippot-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'philippot';

UPDATE candidat SET bio = 'Journaliste et essayiste, directrice de la revue L''Audace, cofondée en 2025, après avoir dirigé la rédaction de Marianne de 2018 à 2024. A lancé son mouvement politique en 2026.',
  date_naissance = '1975-04-15',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-polony-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'polony';

UPDATE candidat SET bio = 'Sénateur de la Vendée et président des Républicains depuis 2025. Ministre de l''Intérieur de septembre 2024 à octobre 2025, président du groupe LR au Sénat de 2014 à 2024.',
  date_naissance = '1960-11-20',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-retailleau-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'retailleau';

UPDATE candidat SET bio = 'Secrétaire national du Parti communiste français depuis 2018 et maire de Saint-Amand-les-Eaux depuis 2025. Député du Nord de 2017 à 2024, candidat à l''élection présidentielle de 2022.',
  date_naissance = '1969-04-16',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-roussel-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'roussel';

UPDATE candidat SET bio = 'Député de la Somme depuis 2017, fondateur du journal Fakir. Journaliste et documentariste (Merci Patron !, César 2017), proche de La France insoumise jusqu''en 2024.',
  date_naissance = '1975-10-18',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-ruffin-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'ruffin';

UPDATE candidat SET bio = 'Secrétaire nationale des Écologistes depuis 2022, réélue en 2025, et conseillère régionale des Hauts-de-France depuis 2021. Désignée par son parti pour une primaire de la gauche abandonnée en juillet 2026.',
  date_naissance = '1986-08-23',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-tondelier-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'tondelier';

UPDATE candidat SET bio = 'Fondateur et président de Reconquête depuis 2021. Journaliste et essayiste, longtemps au Figaro, candidat à l''élection présidentielle de 2022.',
  date_naissance = '1958-08-31',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-zemmour-2026-10-17'),
  bio_verifie_le = '2026-10-17'
WHERE slug = 'zemmour';
