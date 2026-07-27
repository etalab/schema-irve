# Schéma IRVE v3
## Travail en cours (batch 1 sur 2)

*Proposition technique PAN/DGITM pour la DGEC -- mai 2026*

---

## Cadrage

Ce document présente le **premier batch** de la v3 du schéma IRVE. Un **deuxième batch est en préparation**, portant notamment sur la refonte des connecteurs et des champs complémentaires pour la conformité AFIR (voir [section 5](#5-batch-2--prochaines-évolutions)).

Ces travaux combinent l'expertise de l'équipe transport.data.gouv.fr sur la qualité des données IRVE et le **travail de Philippe Thomy (loco-labs) sur la modélisation tarifaire**, qui a permis d'accélérer significativement la construction du volet tarifs en s'appuyant sur ses schémas JSON initiaux et sa connaissance de la spécification OCPI. Philippe Thomy a également effectué une relecture détaillée de ce batch, et ses retours sont en cours d'analyse.

Sources de ce document :

- Spécification technique au format [Table Schema](https://specs.frictionlessdata.io/table-schema/) : [branche `v3-wip`](https://github.com/etalab/schema-irve/tree/v3-wip) (`41b2396`)
- Source Markdown de ce document : [`v3-wip-doc`](https://github.com/etalab/schema-irve/blob/v3-wip-doc/docs/proposition-technique-irve-v3.md) (`a923488`)

### Stratégie de transition : v2.99 versus v3

Le schéma IRVE suit, dans notre proposition, le [versionnement sémantique](https://semver.org/lang/fr/) (SemVer) : un changement de version majeure (v2 → v3) signale des **breaking changes**, c'est-à-dire des modifications incompatibles avec la version précédente. L'ensemble des changements décrits ici constitue la **v3**, qui assume ces ruptures par rapport à la v2 actuelle. Cependant, nous avons cherché à limiter l'impact sur les producteurs autant que possible, ce qui rend envisageable une **version v2.99 intermédiaire** : nous chercherons à publier cette version de transition, qui intégrerait les changements **rétrocompatibles** de la v3 (nouveaux champs facultatifs, descriptions enrichies, contrôles en mode avertissement). Les producteurs pourraient ainsi commencer à migrer progressivement avant la bascule complète en v3, et côté transport.data.gouv.fr, cette étape intermédiaire permettrait d'adapter le validateur, la consolidation et la diffusion en amont.

---

## Vue d'ensemble

À ce stade, le batch 1 de la v3 apporte quatre catégories d'évolutions :

1. **Renforcement de la qualité des données statiques** (champs rendus obligatoires, patterns de validation renforcés, valeur « Non concerné » interdite, contrôles de cohérence)
2. **Refonte des coordonnées géographiques** (remplacement de `coordonneesXY` par `station_latitude` / `station_longitude`, avec clarification que les coordonnées sont celles de la station)
3. **Ajout du connecteur MCS** (Megawatt Charging System) dans les schémas statique et dynamique, pour la recharge poids lourds (en attendant un retravail de la modélisation des connecteurs prévu au batch 2)
4. **Nouveau volet tarifaire** -- un seul fichier CSV supplémentaire suffit à couvrir la complexité tarifaire OCPI, ce qui est un résultat remarquable en termes de simplicité d'intégration

---

## Choix de conception

Le design de la v3 a été guidé par un objectif : **maximiser les gains de qualité tout en minimisant les coûts d'adaptation** pour l'ensemble de la chaîne (producteurs, Qualicharge, PAN transport.data.gouv.fr).

- **Pas de changement de formalisme** : le schéma reste du CSV + Table Schema (Frictionless). Les producteurs conservent leurs outils et pipelines d'export existants, même si le volet tarifaire implique un fichier CSV supplémentaire avec des colonnes JSON.
- **Un seul fichier supplémentaire** pour couvrir toute la complexité tarifaire OCPI. Le recours à des colonnes JSON (`restrictions`, `price_components`) permet de représenter des structures arborescentes sans multiplier les fichiers ni les jointures.
- **Dénormalisation contrôlée** : les propriétés du tarif parent sont répétées sur chaque ligne plutôt que séparées dans un fichier dédié. Un contrôle automatique garantit la cohérence, et les producteurs n'ont qu'un seul fichier à générer.
- **Identifiants AFIREV préfixés** (`tarif_id`, `id_station_itinerance`, `id_pdc_itinerance`) : l'unicité globale est garantie par construction lors de la consolidation nationale, sans registre central supplémentaire.
- **Champs rendus obligatoires uniquement quand déjà renseignés en pratique** (> 95 % des cas) : l'impact réel sur les producteurs est marginal.
- **15 contrôles de cohérence déclaratifs** intégrés au schéma : ils documentent les règles métier de façon lisible et permettent aux validateurs (transport.data, Qualicharge) de les implémenter progressivement sans ambiguïté.
- **Détection automatique des anomalies structurelles** (connecteurs déclarés comme PDC, incohérence coordonnées/INSEE, SIREN invalides) : ces contrôles réduisent le travail manuel de nettoyage côté PAN et améliorent la fiabilité du consolidé national.
- **Compatibilité descendante via v2.99** : les producteurs qui ne peuvent pas migrer immédiatement bénéficient déjà des ajouts rétrocompatibles (nouveaux champs facultatifs, descriptions enrichies) avant la bascule v3.

---

## 1. Schéma statique (`schema-statique.json`)

### 1.1 Champs rendus obligatoires

| Champ | v2 | v3 | Justification |
|-------------|---------|------------|--------|
| `nom_amenageur` | facultatif | **obligatoire** | Présent dans 99 % des déclarations ; cohérence avec le SIREN |
| `siren_amenageur` | facultatif | **obligatoire** | Indispensable pour identifier l'aménageur (vérification SIRENE) |
| `code_insee_commune` | facultatif | **obligatoire** | Permet le croisement géographique ; contrôle de cohérence avec les coordonnées |

### 1.2 Refonte des coordonnées géographiques

| v2 | v3 |
|-------------|--------|
| `coordonneesXY` -- `geopoint` au format `[lon,lat]` | `station_latitude` (`number`) + `station_longitude` (`number`) |

Le champ combiné actuel nécessite un parsing non trivial pour de nombreux producteurs et réutilisateurs ; deux colonnes numériques distinctes sont plus simples et ne justifient pas une structure JSON. Cette refonte répond à trois problèmes constatés :

- **Inversions latitude/longitude** récurrentes dans les déclarations, dues à l'ambiguïté du format `[lon,lat]`. Deux champs nommés explicitement (`station_latitude`, `station_longitude`) réduisent fortement ce risque.
- **Nommage explicite `station_*`** : le schéma v2 indiquait déjà que les coordonnées concernent la *station*, mais le nom de colonne `coordonneesXY` ne le rendait pas évident. Une **analyse des données de production a montré qu'une partie des producteurs renseignent des coordonnées au niveau du PDC** (point de recharge) plutôt qu'au niveau de la station. Le préfixe `station_` dans le nom de colonne rend désormais cette règle difficile à ignorer.
- **Bornes de validité** : les nouveaux champs incluent des contraintes `minimum`/`maximum` ([-90, 90] pour la latitude, [-180, 180] pour la longitude) qui permettent de rejeter les valeurs aberrantes dès la validation.

Un contrôle de cohérence (`coherence-coordonnees-station`) vérifie en complément que tous les PDC d'une même station partagent bien les mêmes coordonnées.

### 1.3 Nouveaux champs

| Champ | Type | Obligatoire | Description |
|-------------|---------|------------|--------|
| `prise_type_mcs` | `boolean` | oui | Prise MCS (Megawatt Charging System) -- recharge poids lourds |
| `tarif_ids` | `array` | non (à discuter) | Clé de jointure vers le fichier tarifaire (voir section 3) |

### 1.4 Contraintes renforcées

| Champ | v2 | v3 | Impact |
|-------------|---------|------------|--------|
| `id_station_itinerance` | Pattern permissif, « Non concerné » accepté | Pattern `FR[A-Z0-9]{3}P…` strict, trigramme AFIREV vérifié, lien vers l'annuaire officiel AFIREV ajouté dans la description. **« Non concerné » interdit.** | Toute station doit avoir un identifiant AFIREV valide |
| `id_pdc_itinerance` | Pattern permissif, « Non concerné » accepté | Pattern `FR[A-Z0-9]{3}E…` strict, contrainte `unique` ajoutée, lien vers l'annuaire officiel AFIREV ajouté dans la description. **« Non concerné » interdit.** | Tout PDC doit avoir un identifiant AFIREV unique |
| `puissance_nominale` | minimum : 0 kW, pas de maximum | minimum : **2,3 kW**, maximum : **1 000 kW** | Élimine les valeurs aberrantes (0 kW, puissances fantaisistes) |
| `code_insee_commune` | description minimale | Clarification « ce n'est pas le code postal », lien vers la liste officielle INSEE | Confusion fréquente avec le code postal |
| `nom_enseigne` | description minimale | Description enrichie (nom commercial du réseau visible sur les bornes) | Clarification uniquement |
| `nom_amenageur` | description minimale | Mention de la cohérence avec le SIREN | Amélioration de la documentation |

> **Changement majeur :** la valeur « Non concerné », auparavant tolérée pour les identifiants station et PDC, est **supprimée en v3**. Les PDC concernés représentent moins de 0,5 % du consolidé national. Une analyse semble montrer qu'environ 80 % d'entre eux sont en accès libre et devraient donc, a priori, disposer d'un identifiant d'itinérance. Il pourrait s'agir d'un problème d'obtention de trigramme AFIREV et de remontée de données par les quelques producteurs concernés, plutôt que d'un cas que le schéma doit compenser.

### 1.5 Clé primaire et unicité

En v2, aucune clé primaire ni contrainte d'unicité n'étaient définies ; l'absence de cette clé était partiellement causée par les valeurs « Non concerné ». La v3 ajoute les deux :

| Ajout | Champ | Effet |
|-------------|---------|--------|
| `primaryKey` | `id_pdc_itinerance` | Déclare la clé primaire du fichier |
| `unique: true` | `id_pdc_itinerance` | Contraint chaque identifiant PDC à être unique dans le fichier |

Ces deux contraintes garantissent l'unicité de chaque point de recharge dans chaque fichier source, ce qui est essentiel pour la fiabilité des données à la source (le fichier consolidé effectue déjà un dédoublonnage en aval).

### 1.6 Contrôles de cohérence (`custom_checks`)

La v3 introduit 15 contrôles automatisés, absents de la v2. Leur mise en place sera progressive et adaptée : le niveau de sévérité (erreur bloquante ou avertissement) reste à définir pour chaque contrôle, en fonction de l'impact sur les producteurs et de la capacité de la consolidation PAN à compenser certaines anomalies en aval. L'objectif est de gagner en qualité sans rejeter excessivement de données.

Liste des contrôles :

| Contrôle | Portée |
|-------------|--------|
| `valid-afirev-trigram` | Vérifie que le trigramme AFIREV existe dans l'annuaire officiel (`id_station_itinerance`, `id_pdc_itinerance`) |
| `coherence-trigram-station-pdc` | Le trigramme de la station et du PDC doivent correspondre |
| `coherence-coordonnees-station` | Les PDC d'une même station doivent partager les mêmes coordonnées |
| `suspect-connecteur-comme-pdc` | Détecte les connecteurs déclarés à tort comme des PDC distincts (~5,6 % du consolidé, soit ~8 800 PDC en trop) |
| `siren-checksum` | Vérifie la clé de contrôle du numéro SIREN (algorithme de Luhn) |
| `siren-online` | Vérifie l'existence du SIREN dans la base SIRENE |
| `opening-hours-value` | Valide les horaires d'ouverture par parsing du sous-ensemble OSM `opening_hours` accepté (le pattern du schéma ne fait qu'un contrôle de forme minimal) |
| `coherence-nom-siren` | Cohérence entre la dénomination sociale et le numéro SIREN |
| `code-insee-exists` | Vérifie l'existence du code INSEE dans le COG (Code Officiel Géographique) |
| `coherence-code-insee-coordonnees` | Le code INSEE doit correspondre aux coordonnées géographiques |
| `coherence-adresse-coordonnees` | L'adresse doit être cohérente avec les coordonnées |
| `foreign-key-array` | Les `tarif_ids` doivent référencer des tarifs existants dans le fichier tarifaire |
| `presence-tarif-adhoc` | Si des tarifs sont déclarés, un tarif de type `AD_HOC_PAYMENT` doit être présent |
| `unicite-type-par-tarif` | Un même PDC ne peut pas avoir deux tarifs du même type (`REGULAR`, `AD_HOC_PAYMENT`) |

---

## 2. Schéma dynamique (`schema-dynamique.json`)

### 2.1 Nouveau champ

| Champ | Type | Obligatoire | Description |
|-------------|---------|------------|--------|
| `etat_prise_type_mcs` | `string` (enum) | non | État du connecteur MCS : `fonctionnel`, `hors_service`, `inconnu` |

Ce champ est le pendant dynamique de `prise_type_mcs` introduit dans le schéma statique. Il suit la même convention que les autres champs `etat_prise_type_*`.

> **Note :** l'état par connecteur est à l'étude et ce point risque de changer.

---

## 3. Nouveau schéma : tarifs (`schema-statique-tarifs.json`)

### 3.1 Principe

**Un seul fichier CSV supplémentaire** suffit à couvrir l'intégralité de la complexité tarifaire OCPI -- c'est un résultat remarquable, rendu possible par l'utilisation de colonnes JSON pour les structures imbriquées (`restrictions`, `price_components`).

Le fichier est structuré autour de deux niveaux :

- **Le tarif** (objet Tariff OCPI), identifié par `tarif_id`. C'est l'unité que l'on rattache à un point de recharge via le champ `tarif_ids` du fichier statique. Le `tarif_id` reprend l'identifiant OCPI du tarif, préfixé par le trigramme AFIREV du producteur (`FR[A-Z0-9]{3}T…`). Ce préfixe garantit l'unicité globale lors de la consolidation nationale, sans imposer de registre central d'identifiants tarifaires.
- **Les tariff elements** (objets TariffElement OCPI) : chaque ligne du fichier CSV est un « enfant » du tarif. Un tariff element décrit une tranche tarifaire (par exemple : tarif de nuit, palier de durée, prix week-end). Un tarif peut comporter un ou plusieurs tariff elements, donc une ou plusieurs lignes dans le fichier.

### 3.2 Champs du fichier tarifaire

Les champs se répartissent en deux catégories : les propriétés du **tarif parent** (répétées à l'identique sur chaque ligne partageant le même `tarif_id`) et les propriétés propres à chaque **tariff element**. Quelques champs supplémentaires sont encore à l'étude et pourront être ajoutés.

**Propriétés du tarif parent** (dénormalisées) :

| Champ | Type | Obligatoire | Description |
|-------------|---------|------------|-----------|
| `tarif_id` | `string` | oui | Identifiant du tarif parent (OCPI Tariff), préfixé AFIREV `FR[A-Z0-9]{3}T…`. Plusieurs lignes (tariff elements) partagent le même `tarif_id`. |
| `devise` | `string` | oui | Code ISO 4217 (`EUR` uniquement) |
| `horodatage_maj_tarif` | `datetime` | oui | Dernière mise à jour (ISO 8601 UTC) |
| `type` | `string` | oui | `REGULAR` ou `AD_HOC_PAYMENT` |
| `tax_included` | `string` | oui | `YES` uniquement (prix TTC obligatoire) |
| `max_price` | `number` | non | Prix maximum TTC par session |

> **Dénormalisation volontaire :** les colonnes `devise`, `horodatage_maj_tarif`, `type`, `tax_included` et `max_price` sont des propriétés du tarif, pas du tariff element. Elles sont donc répétées à l'identique sur chaque ligne d'un même tarif. Ce choix de dénormalisation permet de conserver un seul fichier CSV plat, sans nécessiter de jointure avec un fichier parent. Un contrôle de cohérence (`coherence-tarif-denormalise`) vérifie automatiquement que ces valeurs sont bien identiques au sein de chaque `tarif_id`.

**Propriétés du tariff element** (une valeur distincte par ligne) :

| Champ | Type | Obligatoire | Description |
|-------------|---------|------------|--------|
| `element_index` | `integer` | oui | Index du tariff element au sein de son tarif parent (0-based) |
| `restrictions` | `object` (JSON) | oui | Conditions d'application (horaires, durée, puissance...) |
| `price_components` | `array` (JSON) | oui | Composants de prix (`ENERGY`, `FLAT`, `TIME`, `PARKING_TIME`) |

### 3.3 Sous-schémas JSON et validation

> **Attention :** en cours de design, certains points peuvent évoluer.

Deux JSON Schemas valident les colonnes structurées `restrictions` et `price_components` :

> **Note technique :** les outils de validation standards (Frictionless, Validata) vérifient que le JSON est structuré correctement. Le **validateur IRVE de transport.data.gouv.fr** ira plus loin en validant la structure interne de ces colonnes contre les JSON Schemas associés, via des contrôles dédiés (`json-schema-validation`), garantissant ainsi que les valeurs respectent précisément le modèle OCPI attendu.

**`restrictions.schema.json`** -- Conditions d'application d'un élément tarifaire :

| Propriété | Type | Description |
|-------------|---------|--------|
| `start_time` / `end_time` | `string` HH:MM | Plage horaire |
| `start_date` / `end_date` | `date` | Période de validité |
| `min_kwh` / `max_kwh` | `number` | Bornes d'énergie |
| `min_current` / `max_current` | `number` | Bornes de courant |
| `min_power` / `max_power` | `number` | Bornes de puissance |
| `min_duration` / `max_duration` | `integer` | Bornes de durée (secondes) |
| `day_of_week` | `array` | Jours applicables |
| `reservation` | `enum` | Type de réservation |

**`price-components.schema.json`** -- Composants de prix :

| Propriété | Type | Description |
|-------------|---------|--------|
| `type` | `enum` | `ENERGY`, `FLAT`, `PARKING_TIME`, `TIME` |
| `price` | `number` | Prix unitaire TTC |
| `step_size` | `integer` (>= 1) | Granularité de facturation |

### 3.4 Clé primaire et contrôles

- **Clé primaire** : `(tarif_id, element_index)`
- Validation du trigramme AFIREV sur `tarif_id`
- Validation JSON Schema sur `restrictions` et `price_components`
- Cohérence de l'indexation des éléments
- Cohérence des champs dénormalisés (devise, type, etc.) au sein d'un même tarif

### 3.5 Exemple concret

Un tarif `FRELCT5` avec 5 éléments tarifaires :

| element_index | Restriction | Composants |
|-------------|---------|--------|
| 0 | 06h-00h, durée 0-2h | Énergie : 0,33 EUR/kWh |
| 1 | 06h-00h, durée 2h-3h | Énergie : 0,33 EUR/kWh + stationnement : 4 EUR/h + temps : 4 EUR/h |
| 2 | 06h-00h, durée > 3h | Énergie : 0,33 EUR/kWh + stationnement : 8 EUR/h + temps : 8 EUR/h |
| 3 | 00h-06h (nuit) | Énergie : 0,21 EUR/kWh |
| 4 | Aucune (fallback) | Énergie : 0,21 EUR/kWh |

### 3.6 Tarifs et données quasi-dynamiques

Le design tarifaire est conçu pour être **future-proof vis-à-vis d'une publication dynamique**. Le `tarif_id` est un identifiant stable, référencé depuis le fichier statique. Le fichier tarifaire lui-même peut être régénéré fréquemment (par exemple via une API OCPI) sans nécessiter de mise à jour du fichier statique, tant que les `tarif_id` restent stables. Cela ouvre la voie à une publication quasi temps réel des tarifs -- un point identifié comme relevant du volet dynamique dans AFIR (Table F) -- tout en restant dans le cadre d'un simple fichier CSV servi par URL stable.

---

## 4. Intégration dans le data package

Le fichier `datapackage.json` déclare désormais trois ressources :

| Ressource | Fichier | Schéma |
|-------------|---------|--------|
| `irve-statique` | statique | `schema-statique.json` |
| `irve-statique-tarifs` | tarifs | `schema-statique-tarifs.json` |
| `irve-dynamique` | dynamique | `schema-dynamique.json` |

La relation entre statique et tarifs est assurée par le champ `tarif_ids` (foreign key array) avec vérification d'intégrité référentielle.

---

## 5. Batch 2 : prochaines évolutions

Le deuxième batch, en cours de préparation, portera sur trois axes principaux en vue d'une conformité plus complète avec le règlement AFIR (2023/1804) et son acte d'exécution (2025/655). **Les éléments ci-dessous sont estimatifs et n'ont pas encore été étudiés en détail.**

### 5.1 Refonte des connecteurs

Les champs booléens actuels (`prise_type_ef`, `prise_type_2`, `prise_type_combo_ccs`, etc.) pourraient être remplacés par une **colonne JSON unique `connecteurs`**, décrivant chaque connecteur avec sa puissance, son type de courant (AC/DC), son format (câble/socle), sa tension et son intensité maximales. Ce rework comble deux gaps AFIR critiques : le type de courant par point de recharge (AC/DC, requis par AFIR au niveau du PDC) et la puissance par connecteur (`maxPowerAtSocket`). Le pattern est le même que pour les tarifs : une colonne JSON validée par un JSON Schema dédié.

Côté dynamique, les champs `etat_prise_type_*` (état par connecteur) seront probablement retirés. Ces données sont peu fiables en pratique et l'état au niveau du PDC (`etat_pdc`, `occupation_pdc`) couvre le besoin des usagers.

### 5.2 Champs manquants pour AFIR

Une analyse des Tables A et B de l'acte d'exécution AFIR a identifié les champs à ajouter, notamment :

- **Booléens/enums simples** : paiement sans contact, abonnement, plug-and-charge, recharge intelligente, énergie renouvelable
- **Champs numériques** : nombre de places, nombre de places PMR (en remplacement de l'enum `accessibilite_pmr` actuel)
- **Champs structurés** : types de véhicules (nomenclature UNECE), spécifications véhicule (en remplacement du texte libre `restriction_gabarit`), détails de paiement, liste des eMSP

L'ensemble de ces ajouts est prévu pour s'intégrer dans les fichiers existants, sans créer de fichier supplémentaire.

### 5.3 Nettoyage de champs existants

Certains champs actuels, rendus redondants par les ajouts AFIR, pourront être retirés ou remplacés (par exemple `gratuit`, `paiement_acte`, `cable_t2_attache`, `restriction_gabarit`).

---

## 6. Résumé des impacts pour les producteurs de données

| Catégorie | Impact | Difficulté estimée |
|-------------|---------|--------|
| Champs obligatoires (`nom_amenageur`, `siren_amenageur`, `code_insee_commune`) | Faible : déjà renseignés dans > 95 % des cas | Faible |
| Remplacement `coordonneesXY` par latitude/longitude | Moyen : adaptation des exports | Faible |
| Patterns AFIREV stricts (plus de « Non concerné ») | Fort : les stations non itinérantes doivent être identifiées | Moyen |
| Connecteur MCS | Faible : nouveau booléen, `false` par défaut | Faible |
| Volet tarifaire | Nouveau fichier, adoption progressive (champ facultatif) | Variable |
| Puissance nominale bornée [2,3 -- 1 000 kW] | Faible : élimine les valeurs aberrantes existantes | Faible |
