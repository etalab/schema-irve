# Infrastructures de recharge pour véhicules électriques


Spécification du fichier d'échange relatif aux données concernant la localisation géographique et les caractéristiques techniques des stations et des points de recharge pour véhicules électriques

- nom : irve
- page d'accueil : https://github.com/etalab/schema-irve
- URL du schéma : https://github.com/etalab/schema-irve/raw/v1.0.3/schema.json
- version : 1.0.3
- date de création : 29/06/2018
- date de dernière modification : 17/04/2020
- concerne le pays : FR
- valeurs manquantes représentées par : `[""]`
- contributeurs :
  - Alexandre Bulté, Etalab (auteur) [validation@data.gouv.fr](validation@data.gouv.fr)
  - Charles Nepote (contributeur) [charles.nepote@fing.org](charles.nepote@fing.org)
  - Pierre Dittgen, Jailbreak (contributeur) [pierre.dittgen@jailbreak.paris](pierre.dittgen@jailbreak.paris)
  - Johan Richer, Jailbreak (contributeur) [johan.richer@jailbreak.paris](johan.richer@jailbreak.paris)
- ressources :
  - Exemple de fichier IRVE valide ([lien](https://github.com/etalab/schema-irve/raw/v1.0.3/exemple-valide.csv))
- sources :
  - Décret n° 2017-26 du 12 janvier 2017 relatif aux infrastructures de recharge pour véhicules électriques et portant diverses mesures de transposition de la directive 2014/94/UE du Parlement européen et du Conseil du 22 octobre 2014 sur le déploiement d’une infrastructure pour carburants alternatifs ([lien](https://www.legifrance.gouv.fr/jo_pdf.do?id=JORFTEXT000033860620))
  - Arrêté du 12 janvier 2017 relatif aux données concernant la localisation géographique et les caractéristiques techniques des stations et des points de recharge pour véhicules électriques ([lien](https://www.legifrance.gouv.fr/jo_pdf.do?id=JORFTEXT000033860733))
  - Arrêté du 12 janvier 2017 précisant les dispositions relatives aux identifiants des unités d’exploitation pour la recharge des véhicules électriques ([lien](https://www.legifrance.gouv.fr/jo_pdf.do?id=JORFTEXT000033860743))
  - Définition et structure des identifiants attribués par l&#x27;Association Française pour l&#x27;Itinérance de la Recharge Electrique des Véhicules (AFIREV) ([lien](http://www.afirev.fr/fr/informations-generales/))

## Modèle de données

Ce modèle de données repose sur les 17 champs suivants correspondant aux colonnes du fichier tabulaire.

### `n_amenageur`

- titre : 
- description : Le nom de l'aménageur, c'est à dire de l'entité publique ou privée propriétaire des infrastructures
- type : chaîne de caractères
- exemple : `Société X, Entité Y`
- valeur obligatoire

### `n_operateur`

- titre : 
- description : Le nom de l'opérateur qui opère le réseau d'infrastructure (l'aménageur ou un tiers auquel a été confié la responsabilité par délégation)
- type : chaîne de caractères
- exemple : `Société X, Entité Y`
- valeur obligatoire

### `n_enseigne`

- titre : 
- description : Le nom commercial du réseau
- type : chaîne de caractères
- exemple : `Réseau de recharge ABC`
- valeur obligatoire

### `id_station`

- titre : 
- description : L'identifiant de la station délivré selon les modalités définies à l'article 10 du décret n° 2017-26 du 12 janvier 2017
- type : chaîne de caractères
- exemple : `FR*A68*P68021*A`
- valeur obligatoire

### `n_station`

- titre : 
- description : le nom de la station
- type : chaîne de caractères
- exemple : `Picpus, Belleville, Villiers`
- valeur obligatoire

### `ad_station`

- titre : 
- description : L'adresse complète de la station : [numéro] [rue], [code postal] [ville]
- type : chaîne de caractères
- exemple : `1 avenue de la Paix, 75001 Paris`
- valeur obligatoire

### `code_insee`

- titre : 
- description : Le code INSEE de la commune d'implantation
- type : chaîne de caractères
- exemple : `06088, 2B002 (pour une commune corse)`
- valeur obligatoire
- motif : `^([013-9]\d|2[AB1-9])\d{3}$`

### `Xlongitude`

- titre : 
- description : La longitude en degrés décimaux (point comme séparateur décimal) de la localisation de la station exprimée dans le système de coordonnées WGS84
- type : nombre réel
- exemple : `7.48710500`
- valeur obligatoire

### `Ylatitude`

- titre : 
- description : La latitude en degrés décimaux (point comme séparateur décimal) de la localisation de la station exprimée le système de coordonnées WGS84
- type : nombre réel
- exemple : `47.63495500`
- valeur obligatoire

### `nbre_pdc`

- titre : 
- description : Le nombre de points de recharge sur la station
- type : nombre entier
- exemple : `1, 10`
- valeur obligatoire

### `id_pdc`

- titre : 
- description : L'identifiant du point de recharge délivré selon les modalités définies à l'article 10 du décret n° 2017-26 du 12 janvier 2017
- type : chaîne de caractères
- exemple : `FR*A68*E68021*A*B1*D`
- valeur obligatoire

### `puiss_max`

- titre : 
- description : La puissance maximale délivrée à chaque point de recharge, exprimée en kW, en fonction du contrat d'abonnement de puissance de la station et du type de connecteur
- type : nombre réel
- exemple : `22.00`
- valeur obligatoire

### `type_prise`

- titre : 
- description : Les types de prises ou de connecteurs disponibles sur chaque point de charge
- type : chaîne de caractères
- exemple : `E/F, T2`
- valeur obligatoire

### `acces_recharge`

- titre : 
- description : Modalités d'accès à la recharge
- type : chaîne de caractères
- exemple : `Payant, Gratuit, Sur abonnement`
- valeur obligatoire

### `accessibilité`

- titre : 
- description : Amplitude d'ouverture de la station
- type : chaîne de caractères
- exemple : `24/24 7/7 jours`
- valeur obligatoire

### `observations`

- titre : 
- description : Champ destiné à préciser les modalités d'accès à la recharge, l'accessibilité, le tarif, les horaires d'ouverture, …
- type : chaîne de caractères
- exemple : `Recharge uniquement disponible pendant les horaires d'ouverture du Centre Commercial XY`
- valeur optionnelle

### `date_maj`

- titre : 
- description : Date de mise à jour des données
- type : date (%Y/%m/%d)
- exemple : `2018/08/08, 2015/12/30`
- valeur obligatoire


