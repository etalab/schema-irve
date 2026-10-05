# Infrastructures de recharge pour véhicules électriques - données statiques

Spécification du fichier d'échange relatif aux données statiques concernant la localisation géographique et les caractéristiques techniques des stations et des points de recharge pour véhicules électriques

## Version 3 du schéma

La version 3 du schéma est publiée en alpha. Elle couvre les données exigées par le règlement AFIR (UE 2023/1804) et son règlement d'exécution (UE) 2025/655, et s'accompagne d'un nouveau schéma pour les tarifs. Ses objectifs et ses choix sont expliqués dans la [note de conception](../docs/note-conception-irve-v3.md) ; la liste détaillée des champs figure dans ses [annexes](../docs/note-conception-irve-v3-annexes.md). Vos retours sont les bienvenus (voir « Voir aussi »).


## Contexte

Dans le but de constituer un répertoire national de données relatif à l’offre de recharge pour véhicules électriques, ouvert et accessible à tous, les aménageurs d’infrastructures de recharge pour véhicules électriques (IRVE), ou les personnes qu’ils désignent, doivent publier sur la plateforme data.gouv.fr les données pour tout point de recharge en service et ouvert au public. L’ouverture des données statiques relatives à la localisation et aux caractéristiques techniques de ces infrastructures s’effectue selon les modalités définies dans [l'arrêté du 4 mai 2021](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000043475363).

**Documents de cadrage juridique**
  * [Décret n° 2021-546 du 4 mai 2021 portant modification du décret n° 2017-26 du 12 janvier 2017 relatif aux infrastructures de recharge pour véhicules électriques et portant diverses mesures de transposition de la directive 2014/94/UE du Parlement européen et du Conseil du 22 octobre 2014 sur le déploiement d'une infrastructure pour carburants alternatifs](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000043475363)
  * [Arrêté du 4 mai 2021 relatif aux données concernant la localisation géographique et les caractéristiques techniques des stations et des points de recharge pour véhicules électriques](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000043475441)

**Documents de cadrage technique**
  * [Fichier de consolidation des stations de recharge de véhicules électriques sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/fichier-exemple-stations-de-recharge-de-vehicules-electriques/)
  * [Définition et structure des identifiants attribués par l'Association Française pour l'Itinérance de la Recharge Electrique des Véhicules \(AFIREV\)](https://afirev.fr/fr/informations-generales/)

## Définition des objets et représentation

* Les fichiers publiés au schéma listent des points de recharge, « une interface associée à un emplacement de stationnement qui permet de recharger un seul véhicule électrique à la fois ». Chaque ligne du fichier représente donc un point de recharge (abbrévié « pdc »). Chaque point de recharge a un identifiant unique `id_pdc_itinerance`, délivré selon les modalités de l'AFIREV, de la forme `FR` + code de l'unité d'exploitation + `E` + suffixe (par exemple `FRA68E680210015`).
* Un point de recharge peut présenter une ou plusieurs prises (appelés également connecteurs), par exemple : une prise domestique E/F et une prise Type 2. Par définition d’un point de recharge, une seule des prises d’un point de recharge est utilisée pour recharger un véhicule électrique à la fois, puisque le point de recharge ne présente qu’une seule place de stationnement. Les types de prises les plus courants sont décrits par des colonnes booléennes (`prise_type_2`, `prise_type_combo_ccs`…), les autres par la liste `prise_type_autre`.
* Les points de recharge sont regroupés en stations, « une zone comportant une borne de recharge associée à un ou des emplacements de stationnement ou un ensemble de bornes de recharge associées à des emplacements de stationnement, exploitée par un ou plusieurs opérateurs ». Comme chaque ligne du fichier correspond à un point de recharge, pour une station, il y a dans le fichier autant de lignes que nombre de point de recharge pour cette station. Par exemple, une station comportant 4 points de recharge sera matérialisée par 4 lignes différentes dans le fichier et pour chaque ligne un champ `nb_pdc` renseigné avec la valeur « 4 ». Les informations concernant la station (identifiant, nom…) sont dupliquées à l’identique sur chacune des lignes de la station.
* Les stations appartiennent à des aménageurs et sont opérées par des opérateurs. L’aménageur correspond au « maître d'ouvrage d'une infrastructure de recharge jusqu'à sa mise en service ou la personne offrant un service de recharge, propriétaire ou locataire de l'infrastructure dès lors qu'elle a été mise en service » et l’opérateur « la personne qui exploite une infrastructure de recharge pour le compte d'un aménageur dans le cadre d'un contrat ou pour son propre compte s'il en est l'aménageur ». Les données correspondant aux opérateurs et aménageurs sont dupliquées sur toutes les lignes des points de recharge de chaque opérateur et aménageur. L’aménageur d’une infrastructure publique de recharge électrique est l’entitée tenue de publier un fichier de ses points de recharge selon [l’arrêté du 4 mai 2021](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000043475441).
* Les stations comprenent une ou plusieurs bornes. Une borne est « un appareil fixe raccordé à un point d'alimentation électrique, comprenant un ou plusieurs points de recharge et pouvant intégrer notamment des dispositifs de communication, de comptage, de contrôle ou de paiement ». Une borne peut comprendre plusieurs points de recharge, c’est à dire que plusieurs véhicules peuvent se charger en même temps à la même borne sur plusieurs emplacements dédiés. Le choix du nombre de bornes est un choix architectural dépendant de la configuration des lieux (combien de « supports verticaux », et sont-ils mutualisés entre plusieurs points de recharge) et n’a pas d’incidence sur le service offert, puisque le nombre de véhicules pouvant se charger simultanément dépend du nombre de points de recharge. La définition de la borne au sens du décret n° 2021-546 du 4 mai 2021 peut donc différer de l’acceptation grand public du mot borne, qui parfois désigne un point de recharge ou une prise au sens de ce décret. Les bornes ne sont pas modélisées dans le présent schéma.


Pour le reste des définitions les publicateurs pourront se rapporter au [décret n° 2021-546 du 4 mai 2021](https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000043475363) en cas de besoin. Le projet Qualicharge, publiant des données conformes à ce schéma IRVE statique, [documente également le modèle de données de manière approfondie](https://github.com/MTES-MCT/qualicharge/blob/add-modele-documentation/docs/modele.md).

## Lien avec les données dynamiques

Un fichier statique décrit des caractéristiques des points de recharge et de leurs stations amenées à peu évoluer. Les informations temps réel quant à la disponibilité de ces points de recharge sont à publier dans un fichier séparé au format [IRVE dynamique](https://schema.data.gouv.fr/etalab/schema-irve-dynamique/).

## Lien avec les données tarifaires

Les prix de la recharge ad hoc sont publiés dans un fichier séparé au format [IRVE tarifs](../tarifs/README.md). La colonne `tarif_ids` du fichier statique liste, pour chaque point de recharge, les identifiants des tarifs qui s'y appliquent.

## Création d'un fichier de données conforme

* Les données collectées doivent respecter un formalisme particulier (schéma de données) décrit sur [la section documentation](https://schema.data.gouv.fr/etalab/schema-irve-statique/latest/documentation.html) de cette page.
* Les données sont à remplir au format CSV, encodage UTF-8.
* Plusieurs solutions existent pour générer ce fichier CSV.

## Utilisation de notre outil d'aide à la saisie

> Les outils ci-dessous (parcours de publication, fichier exemple, consolidation) fonctionnent avec la version du schéma publiée sur schema.data.gouv.fr. Ils prendront en charge la version 3 à sa publication finale.

Pour être guidé pas à pas, merci de vous rendre sur la [documentation officielle](https://doc.transport.data.gouv.fr/producteurs/infrastructures-de-recharge-de-vehicules-electriques-irve) de transport.data.gouv.fr, Point d'accès national aux données de transport.

Pour faciliter le remplissage des données, Etalab met à disposition un générateur CSV conforme au schéma de données, vous permettant de remplir les différents champs demandés. Cet outil vous permet de vous assurer que les données que vous remplissez sont au bon format. Pour l'utiliser, rendez-vous sur [le parcours de publication dédié](https://www.data.gouv.fr/admin/datasets/structured?schema=etalab%2Fschema-irve-statique), vous pourrez alors publier votre fichier à partir : 
- d'un fichier csv déjà existant. (vous pouvez partir de [ce fichier exemple](https://www.data.gouv.fr/fr/datasets/fichier-exemple-stations-de-recharge-de-vehicules-electriques/).
- d'un formulaire
- d'un tableur (encore en expérimentation)

Une fois vos données chargées ou remplies, un formulaire vous proposera de les publier sur data.gouv.fr.

## Consolidation

Etalab réalise une consolidation automatique des jeux de données IRVE conformes déposés sur data.gouv.fr. Le code est [disponible ici](https://github.com/etalab/notebooks/tree/master/irve-v2). Le fichier en résultant est [publié ici sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5448d3e0c751df01f85d0572).
Vous pouvez également visualiser son contenu sur une carte en passant par le [Point d’Accès National](https://transport.data.gouv.fr/datasets/fichier-consolide-des-bornes-de-recharge-pour-vehicules-electriques).

Le Point d'Accès National publie par ailleurs une [consolidation nationale (bêta) des données statiques et dynamiques](https://transport.data.gouv.fr/datasets/beta-base-nationale-des-points-de-recharge-pour-vehicules-electriques-en-france-irve), validée et dédoublonnée par `id_pdc_itinerance`. Les problèmes de qualité détectés sur les données consolidées sont suivis sur le dépôt [consolidation-irve-data-quality](https://github.com/transportdatagouvfr/consolidation-irve-data-quality).

En cas de non consolidation de vos données, la raison principale possible est que vos données contiennent des erreurs et donc ne respectent pas le schéma. Nous vous invitons à les corriger et à utiliser l’[outil de validation Validata](https://validata.fr/table-schema?schema_name=schema-datagouvfr.etalab%2Fschema-irve-statique) pour vérifier la qualité de vos données.

## Voir aussi

* [Fichier gabarit à télécharger au format csv](https://www.data.gouv.fr/fr/datasets/fichier-exemple-stations-de-recharge-de-vehicules-electriques/) (proposé par Etalab)
* Pour poser une question, commenter, faire un retour d’usage ou contribuer à l’amélioration du modèle de données, vous pouvez :
  * adresser un message à [contact@transport.data.gouv.fr](mailto:contact@transport.data.gouv.fr)
  * ouvrir un ticket sur le [dépôt GitHub du schéma](https://github.com/etalab/schema-irve/issues/new)
