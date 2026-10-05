# Infrastructures de recharge pour véhicules électriques - données dynamiques

Spécification du fichier d'échange relatif aux données dynamiques concernant la disponibilité et l’état de fonctionnement des points de recharge et de leurs connecteurs pour véhicules électriques

## Contexte

Dans le but de constituer un répertoire national de données relatif à l’offre de recharge pour véhicules électriques, ouvert et accessible à tous, les aménageurs d’infrastructures de recharge pour véhicules électriques (IRVE), ou les personnes qu’ils désignent, doivent publier sur la plateforme data.gouv.fr les données pour tout point de recharge en service et ouvert au public. L’ouverture des données dynamiques relatives à l’état de fonctionnement et la disponibilité des points de recharge et de leurs connecteurs s’effectue selon les modalités définies par arrêté et par le règlement AFIR (UE 2023/1804) : son [règlement d'exécution (UE) 2025/655](https://eur-lex.europa.eu/legal-content/FR/TXT/HTML/?uri=CELEX:32025R0655#art_2) impose une mise à jour des données dynamiques au plus tard une minute après toute modification.

La version 3 du schéma est publiée en alpha. Ses objectifs et ses choix sont expliqués dans la [note de conception](../docs/note-conception-irve-v3.md) ; la liste détaillée des champs figure dans ses [annexes](../docs/note-conception-irve-v3-annexes.md).

## Documents de cadrage technique

- [Définition et structure des identifiants attribués par l'Association Française pour l'Itinérance de la Recharge Électrique des Véhicules (AFIREV)](https://afirev.fr/fr/informations-generales/)

## Lien avec les données statiques

Chaque ligne du fichier correspond à un point de recharge, identifié par `id_pdc_itinerance` (un seul état par point et par fichier). Cet identifiant est une clé étrangère vers le fichier publié au [schéma IRVE statique](https://schema.data.gouv.fr/etalab/schema-irve-statique/) : il suit le même format AFIREV (`FR` + code de l'unité d'exploitation + `E` + suffixe) et doit y exister. Un fichier au schéma IRVE dynamique ne contient que des informations temps réel concernant la disponibilité et l’état de fonctionnement des points de recharge. Pour accéder aux caractéristiques complètes des points de recharge, de leurs stations, opérateurs, localisation, etc, il convient de se référer au fichier IRVE statique correspondant.

## Création d'un fichier de données conforme

Les données collectées doivent respecter un formalisme particulier (schéma de données) décrit sur la section documentation de cette page.

Les données sont à remplir au format CSV, encodage UTF-8.

Pour être conformes, les données dynamiques doivent faire référence aux données statiques via la clé commune  `id_pdc_itinerance`. 
Chaque nouvel état de fonctionnement ou de disponibilité d’un point de recharge (ou d’un de ses connecteurs) doit nécessairement entraîner la mise à jour des données dynamiques. Chaque ligne porte l'horodatage de l'état publié, en UTC (`horodatage`).

## Consolidation

Le Point d'Accès National publie une [consolidation nationale (bêta) des données statiques et dynamiques](https://transport.data.gouv.fr/datasets/beta-base-nationale-des-points-de-recharge-pour-vehicules-electriques-en-france-irve). Les problèmes de qualité détectés sur les flux dynamiques sont suivis sur le dépôt [consolidation-irve-data-quality](https://github.com/transportdatagouvfr/consolidation-irve-data-quality).

## Voir aussi

- [Documentation sur les données dynamiques](https://doc.transport.data.gouv.fr/producteurs/infrastructures-de-recharge-de-vehicules-electriques-irve/donnees-dynamiques)
- Pour poser une question, commenter, faire un retour d’usage ou contribuer à l’amélioration du modèle de données, vous pouvez :
  - adresser un message à [irve@transport.data.gouv.fr](mailto:irve@transport.data.gouv.fr)
  - ouvrir un ticket sur le dépôt [GitHub du schéma](https://github.com/etalab/schema-irve/issues/new)
