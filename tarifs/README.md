# Infrastructures de recharge pour véhicules électriques - données tarifaires

Spécification du fichier d'échange relatif aux prix de la recharge ad hoc (sans contrat préalable) pratiqués sur les points de recharge pour véhicules électriques ouverts au public.

## Contexte

Le règlement AFIR (UE 2023/1804) impose la publication du prix de la recharge ad hoc (entrée F3 du tableau F de l'annexe du [règlement d'exécution (UE) 2025/655](https://eur-lex.europa.eu/legal-content/FR/TXT/HTML/?uri=CELEX:32025R0655#anx_1)). Ce schéma, nouveau en version 3, porte cette information dans un fichier distinct du fichier statique.

La version 3 du schéma est publiée en alpha. Ses objectifs et ses choix sont expliqués dans la [note de conception](../docs/note-conception-irve-v3.md) ; la liste détaillée des champs figure dans ses [annexes](../docs/note-conception-irve-v3-annexes.md).

## Modèle

Le fichier reprend le modèle tarifaire de la spécification [OCPI](https://github.com/ocpi/ocpi/blob/v2.3.0/mod_tariffs.asciidoc) :

* un **tarif**, identifié par `tarif_id`, est composé d'un ou plusieurs **éléments tarifaires** ; chaque ligne du fichier correspond à un élément, numéroté par `element_index` ;
* chaque élément porte ses **conditions d'application** (colonne `restrictions` : plage horaire, jours, durée, énergie, puissance…) et ses **composants de prix** (colonne `price_components` : énergie au kWh, temps de charge et de stationnement à l'heure, forfait) ;
* comme en OCPI, pour chaque type de composant s'applique le premier élément, dans l'ordre de `element_index`, dont les conditions sont satisfaites. Les conditions s'entendent en heure locale de la station ;
* seul le prix ad hoc est publié (`type` = `AD_HOC_PAYMENT`), en euros, toutes taxes comprises.

Les colonnes `restrictions` et `price_components` contiennent du JSON. Leur contenu est défini par deux JSON Schema, qui font foi au même titre que le Table Schema : [`restrictions.schema.json`](restrictions.schema.json) et [`price-components.schema.json`](price-components.schema.json).

## Lien avec les données statiques

L'identifiant `tarif_id` est délivré selon les modalités de l'AFIREV, de la forme `FR` + code de l'unité d'exploitation + `T` + suffixe libre. La colonne `tarif_ids` du [fichier statique](../statique/README.md) liste, pour chaque point de recharge, les tarifs qui s'y appliquent ; chacun doit exister dans le fichier tarifs. Un même tarif peut s'appliquer à plusieurs points de recharge.

## Création d'un fichier de données conforme

* Les données sont à remplir au format CSV, encodage UTF-8. Une cellule JSON est entourée de guillemets et ses guillemets internes sont doublés.
* Le fichier [`exemple-valide-tarifs.csv`](exemple-valide-tarifs.csv) décrit un tarif complet : prix de l'énergie différent le jour et la nuit, frais de temps et de stationnement au-delà d'une certaine durée.
* Le prix ad hoc relève des données dynamiques au sens d'AFIR : le fichier est à mettre à jour au plus tard une minute après toute modification. Chaque ligne porte l'horodatage de dernière mise à jour du tarif, en UTC (`horodatage_maj_tarif`).

## Voir aussi

* Pour poser une question, commenter, faire un retour d’usage ou contribuer à l’amélioration du modèle de données, vous pouvez :
  * adresser un message à [irve@transport.data.gouv.fr](mailto:irve@transport.data.gouv.fr)
  * ouvrir un ticket sur le [dépôt GitHub du schéma](https://github.com/etalab/schema-irve/issues/new)
