# Schéma IRVE v3 : annexes

> **Document temporaire.** Cette annexe remplace l'affichage des champs sur [schema.data.gouv.fr](https://schema.data.gouv.fr/), qui ne sera disponible que pour la version finale `v3.0.0`.

*Version `v3.0.0-alpha.1`. Généré automatiquement à partir des schémas.*

- [A. Champs du fichier statique](#a-champs-du-fichier-statique)
- [B. Champs du fichier dynamique](#b-champs-du-fichier-dynamique)
- [C. Champs du fichier tarifs](#c-champs-du-fichier-tarifs)
- [D. Correspondance avec les tableaux A, B et F d'AFIR](#d-correspondance-avec-les-tableaux-a-b-et-f-dafir)
- [E. Sous-schémas JSON du fichier tarifs](#e-sous-schémas-json-du-fichier-tarifs)
- [F. Contrôles déclarés (`custom_checks`)](#f-contrôles-déclarés-custom_checks)

Dans les annexes A à C, chaque champ est présenté avec son type, son caractère obligatoire (**obligatoire** = cellule vide refusée ; facultatif = cellule vide acceptée, information inconnue), l'entrée AFIR qu'il porte le cas échéant, puis sa description et ses contraintes.

## A. Champs du fichier statique

Clé primaire : `id_pdc_itinerance`. 63 champs.

### Station (36 champs)

**`nom_amenageur`** · string · obligatoire

La dénomination sociale de l'aménageur, c'est à dire de l'entité publique ou privée propriétaire des infrastructures. Doit être cohérent avec le numéro SIREN renseigné. Vous pouvez accéder à cette dénomination exacte sur le site annuaire-entreprises.data.gouv.fr.

**`siren_amenageur`** · string · obligatoire

Le numero SIREN de l'aménageur issue de la base SIRENE des entreprises. Vous pouvez récupérer cet identifiant sur le site annuaire-entreprises.data.gouv.fr. *(motif : `^\d{9}$`)*

**`contact_amenageur`** · string · facultatif

Adresse courriel de l'aménageur. Favoriser les adresses génériques de contact. Cette adresse sera utilisée par les services de l'Etat en cas d'anomalie ou de besoin de mise à jour des données.

**`nom_operateur`** · string · obligatoire · AFIR A1

La dénomination sociale de l'opérateur. L'opérateur est l'entité qui exploite l'infrastructure de recharge pour le compte d'un aménageur dans le cadre d'un contrat ou pour son propre compte s'il est l'aménageur. Vous pouvez accéder à cette dénomination exacte sur le site annuaire-entreprises.data.gouv.fr.

**`contact_operateur`** · string · obligatoire

Adresse courriel de l'opérateur. Favoriser les adresses génériques de contact.

**`telephone_operateur`** · string · obligatoire · AFIR A5

Numéro de téléphone de l'assistance offerte aux utilisateurs de la station (assistance téléphonique joignable pendant les heures d'ouverture, au titre de l'obligation d'assistance du service de recharge). Format imposé par la colonne « Format » du champ A5 de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 : indicatif pays précédé de « + », un espace, puis le numéro complet en un seul bloc (indicatif régional inclus s'il existe, zéro de départ conservé) ; un numéro d'extension éventuel est ajouté après un tiret, immédiatement après le numéro complet ; aucun autre tiret, espace ou parenthèse. Exemples : "+33 0199000000", avec extension "+33 0199000000-12". *(motif : `^\+[1-9][0-9]{0,2} [0-9]{4,15}(-[0-9]{1,8})?$`)*

**`nom_enseigne`** · string · obligatoire · AFIR A2

Le nom commercial du réseau de recharge, tel qu'il est visible sur les bornes ou affiché pour les usagers. Ce nom peut différer de la dénomination sociale de l'aménageur ou de l'opérateur.

**`id_station_itinerance`** · string · obligatoire

L'identifiant de la station délivré selon les modalités définies à l'article 10 du décret n° 2017-26 du 12 janvier 2017. Cet ID débute par FR suivi du trigramme de l'unité d'exploitation délivré par l'AFIREV (déclaré et présent dans la liste officielle : https://afirev.fr/prefixes/consulter-l-annuaire/), suivi de "P" pour "pool" qui veut dire "station" en anglais (https://afirev.fr/fr/informations-generales/). Ne pas ajouter les séparateurs *. *(motif : `^(FR[A-Z0-9]{3}P[A-Z0-9]+)$`)*

**`id_station_local`** · string · facultatif

Identifiant de la station dans les systèmes du producteur de données. Sert de clé de rapprochement entre le fichier publié et ces systèmes. Laisser vide plutôt que d'y recopier id_station_itinerance.

**`nom_station`** · string · obligatoire

Le nom de la station.

**`adresse_station`** · string · obligatoire · AFIR A13

L'adresse complète de la station : [numéro] [rue] [code postal] [ville]. Elle localise l'accès depuis la voie publique ; la position exacte de la station est portée par station_latitude et station_longitude.

**`complement_localisation`** · string · facultatif · AFIR A8

Information complémentaire de localisation fine de la station, en texte libre : niveau de parking, position dans l'ouvrage, point de repère, etc. (champ A8 « Additional geographic location information » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Particulièrement utile en parking souterrain ou centre commercial. Ce champ n'est pas un complément d'adresse postale et ne doit pas être utilisé pour le géocodage.

**`code_postal`** · string · obligatoire · AFIR A12

Le code postal de la station, sur 5 chiffres, sous forme de chaîne de caractères afin de préserver un éventuel zéro initial (champ A12 « Postal code » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Attention, le code postal est distinct du code INSEE de la commune (renseigné dans le champ code_insee_commune). *(motif : `^[0-9]{5}$`)*

**`code_insee_commune`** · string · obligatoire

Le code INSEE de la commune d'implantation (attention, ce n'est pas le code postal). La liste des codes peut se retrouver sur le site de l'INSEE : https://www.insee.fr/fr/information/2560452 *(motif : `^([013-9]\d\|2[AB1-9])\d{3}$`)*

**`station_latitude`** · number · obligatoire · AFIR A7

La latitude en degrés décimaux (point comme séparateur décimal) de la localisation de la station exprimée dans le système de coordonnées WGS84. Position exacte de la station, qui peut différer de l'accès voie publique (adresse_station). *(≥ -90 ; ≤ 90)*

**`station_longitude`** · number · obligatoire · AFIR A7

La longitude en degrés décimaux (point comme séparateur décimal) de la localisation de la station exprimée dans le système de coordonnées WGS84. Position exacte de la station, qui peut différer de l'accès voie publique (adresse_station). *(≥ -180 ; ≤ 180)*

**`nb_pdc`** · integer · obligatoire · AFIR A3

Le nombre de points de recharge sur la station. *(≥ 1)*

**`puissance_maximale_station_kw`** · number · obligatoire · AFIR B5

Puissance maximale totale, en kW, que la station peut fournir simultanément à l'ensemble de ses points de recharge. Cette valeur peut être inférieure à la somme des puissances nominales des points de recharge : le raccordement au réseau de distribution ne permet pas toujours de fournir la pleine puissance sur tous les points en même temps. *(≥ 2.3 ; unité : kW)*

**`emsp`** · array · facultatif · AFIR B7

Fournisseurs de services de mobilité proposant une recharge sur la base d'un contrat (abonnement), acceptés à la station. Liste, au format JSON (guillemets doubles), des identifiants d'unités d'exploitation de mobilité : codes à 5 caractères (préfixe pays sur 2 lettres — FR pour les unités françaises — suivi de 3 caractères) attribués par l'AVERE et publiés par l'AFIREV. Ces codes sont tenus au même registre AFIREV que les préfixes d'unités d'exploitation de recharge (ceux des champs id_station_itinerance, id_pdc_itinerance et tarif_ids) : le registre étant un espace de noms unique, un même code peut légitimement désigner un acteur qui est à la fois opérateur de recharge et de mobilité. *(motif des éléments : `^[A-Z]{2}[A-Z0-9]{3}$`)*

**`condition_acces`** · string · obligatoire

Éventuelles conditions d’accès à la station, hors gabarit. Dans le cas d'un accès libre sans contrainte matérielle physique (ex : absence de barrière) ni restriction d'usager (ex : borne accessible pour n'importe quel type et modèle de voiture électrique), indiquer "Accès libre". Dans le cas d'un accès limité / réservé qui nécessite une identification ou passage d'une barrière, indiquer "Accès réservé" (ce type d'accès inclut les IRVE sur le réseau autoroutier payant - passage péage). *(valeurs : `Accès libre`, `Accès réservé`)*

**`horaires`** · string · obligatoire · AFIR A14

Amplitude d’ouverture de la station, dans un sous-ensemble de la syntaxe OSM opening_hours (https://wiki.openstreetmap.org/wiki/Key:opening_hours) : 24/7, ou des règles séparées par un point-virgule associant des jours en anglais abrégés (Mo-Fr, Mo,We,Fr) à des plages HH:MM-HH:MM. Les constructions avancées (jours fériés, fermetures, mois, heures solaires, commentaires, règles de repli) ne sont pas acceptées. Les jours et plages horaires s'entendent en heure locale de la station : Europe/Paris en métropole, fuseau local outre-mer. *(motif : `^(.*?)((\d{1,2}:\d{2})-(\d{1,2}:\d{2})\|24/7)$`)*

**`nb_places`** · integer · facultatif · AFIR A18

Nombre d'emplacements de stationnement équipés pour la recharge sur la station (champ A18 « Number of parking spaces » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Information au niveau de la station : la valeur est identique pour tous les points de recharge d'une même station. *(≥ 0)*

**`nb_places_pmr`** · integer · facultatif · AFIR A19

Nombre de places de stationnement de la station dotées d'un point de recharge accessible aux personnes à mobilité réduite (PMR), qu'elles leur soient réservées ou non (champ A19 « Number of parking spaces for people with disabilities » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Information au niveau de la station : la valeur est identique pour tous les points de recharge d'une même station. Laisser vide si l'information n'est pas connue (ne pas indiquer 0 par défaut). *(≥ 0)*

**`gabarit_masse_max_t`** · number · facultatif · AFIR A17

Masse maximale du véhicule, en tonnes, autorisée à accéder à la station (remorque comprise). L'une des spécifications du champ A17 « Vehicle specifications permitted » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR. Information au niveau de la station. Laisser vide si l'information n'est pas connue. *(≥ 0 ; unité : t)*

**`gabarit_hauteur_max_m`** · number · facultatif · AFIR A17

Hauteur maximale du véhicule, en mètres, autorisée à accéder à la station (remorque comprise). L'une des spécifications du champ A17 « Vehicle specifications permitted » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR. Information au niveau de la station. Laisser vide si l'information n'est pas connue. *(≥ 0 ; unité : m)*

**`gabarit_longueur_max_m`** · number · facultatif · AFIR A17

Longueur maximale du véhicule, en mètres, autorisée à accéder à la station (remorque comprise). L'une des spécifications du champ A17 « Vehicle specifications permitted » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR. Information au niveau de la station. Laisser vide si l'information n'est pas connue. *(≥ 0 ; unité : m)*

**`gabarit_largeur_max_m`** · number · facultatif · AFIR A17

Largeur maximale du véhicule, en mètres, autorisée à accéder à la station (remorque comprise). L'une des spécifications du champ A17 « Vehicle specifications permitted » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR. Information au niveau de la station. Laisser vide si l'information n'est pas connue. *(≥ 0 ; unité : m)*

**`type_vehicule`** · array · facultatif · AFIR A16

Catégories de véhicules pouvant utiliser la station, au sens de l'article R.311-1 du code de la route : L (deux ou trois roues et quadricycles), M1 (voitures particulières), M2 et M3 (autobus et autocars), N1 (camionnettes), N2 et N3 (camions). Liste au format JSON (guillemets doubles). Information au niveau de la station. Autres catégories dans type_vehicule_autre. *(éléments parmi : `L`, `M1`, `M2`, `M3`, `N1`, `N2`, `N3`)*

**`type_vehicule_autre`** · array · facultatif · AFIR A16

Autres catégories de véhicules pouvant utiliser la station, absentes de type_vehicule. Liste au format JSON (guillemets doubles) de chaînes libres. Information au niveau de la station.

**`presence_borniste`** · boolean · facultatif · AFIR A4

Présence sur le site de la station de personnel pouvant assister l'usager dans sa recharge (« borniste »), de façon permanente ou aux horaires d'ouverture (champ A4 « Service support » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Information au niveau de la station : la valeur est identique pour tous les points de recharge d'une même station. Indiquer "true" si du personnel est présent, "false" uniquement si l'absence de personnel est avérée. Laisser vide si l'information n'est pas connue (ne pas indiquer "false" par défaut).

**`equipement_afir`** · array · obligatoire · AFIR A6

Services et installations proposés à l'usager dans les environs immédiats de la station, parmi les catégories normatives du champ A6 « Installations proposant à l'utilisateur des services associés » de la Table A de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR. Liste, au format JSON (guillemets doubles), parmi : parking_couvert (parc de stationnement couvert permettant la recharge), parking_eclaire (parc de stationnement éclairé permettant la recharge), restauration (service de restauration), sanitaires, repos (installations de repos). Exemple : ["sanitaires", "restauration"]. Information au niveau de la station. Le règlement impose de déclarer chaque installation (oui/non) : la liste fournie vaut déclaration complète, toute catégorie absente de la liste est déclarée absente de la station. Une station sans aucune de ces installations déclare la liste vide []. Champ obligatoire : une cellule vide n'est pas acceptée. Compléments éventuels dans equipement_ocpi et equipement_autre. *(éléments parmi : `parking_couvert`, `parking_eclaire`, `restauration`, `sanitaires`, `repos`)*

**`equipement_ocpi`** · array · facultatif

Services et installations complémentaires des environs immédiats de la station, exprimés selon l'énumération Facility du standard OCPI 2.2.1. Complète (sans s'y substituer) le socle normatif AFIR porté par equipement_afir ; un même service peut être déclaré dans les deux colonnes. Liste, au format JSON (guillemets doubles), parmi : AIRPORT, BIKE_SHARING, BUS_STOP, CAFE, CARPOOL_PARKING, FUEL_STATION, HOTEL, MALL, METRO_STATION, MUSEUM, NATURE, PARKING_LOT, RECREATION_AREA, RESTAURANT, SPORT, SUPERMARKET, TAXI_STAND, TRAIN_STATION, TRAM_STOP, WIFI. Exemple : ["HOTEL", "WIFI"]. Information au niveau de la station. *(éléments parmi : `AIRPORT`, `BIKE_SHARING`, `BUS_STOP`, `CAFE`, `CARPOOL_PARKING`, `FUEL_STATION`, `HOTEL`, `MALL`, `METRO_STATION`, `MUSEUM`, `NATURE`, `PARKING_LOT`, `RECREATION_AREA`, `RESTAURANT`, `SPORT`, `SUPERMARKET`, `TAXI_STAND`, `TRAIN_STATION`, `TRAM_STOP`, `WIFI`)*

**`equipement_autre`** · array · facultatif · AFIR A6

Autres services ou installations des environs immédiats de la station ne figurant ni dans equipement_afir ni dans equipement_ocpi, en texte libre (couvre la modalité « autre (exprimé en texte libre) » du champ A6 de l'annexe du règlement d'exécution (UE) 2025/655 pris en application du règlement AFIR). Liste, au format JSON (guillemets doubles), de chaînes libres. Information au niveau de la station.

**`raccordement`** · string · facultatif

Type de raccordement de la station au réseau de distribution d'électricité : direct (point de livraison exclusivement dédié à la station) ou indirect. *(valeurs : `Direct`, `Indirect`)*

**`num_pdl`** · string · facultatif

Numéro du point de livraison d'électricité, y compris en cas de raccordement indirect. Dans le cas d'un territoire desservi par ENEDIS, ce numéro doit compoter 14 chiffres.

**`enr`** · boolean · facultatif · AFIR B10

Électricité délivrée par la station 100 % d'origine renouvelable, attestée par des garanties d'origine au sens du mécanisme européen. Il s'agit d'un attribut contractuel de fourniture d'électricité, indépendant d'un éventuel raccordement physique direct à une production renouvelable. Indiquer "true" si vrai, "false" uniquement si l'électricité n'est effectivement pas 100 % renouvelable. Laisser vide si l'information n'est pas connue (ne pas indiquer "false" par défaut).

### Point de recharge (27 champs)

**`id_pdc_itinerance`** · string · obligatoire · AFIR B1

L'identifiant du point de recharge délivré selon les modalités définies à l'article 10 du décret n° 2017-26 du 12 janvier 2017. Cet ID débute par FR suivi du trigramme de l'unité d'exploitation délivré par l'AFIREV (déclaré et présent dans la liste officielle : https://afirev.fr/prefixes/consulter-l-annuaire/), suivi de "E" pour l'équivalent du point de recharge en anglais EVSE - Electric Vehicule Supply Equipment (https://afirev.fr/fr/informations-generales/). Ne pas mettre de séparateur * ou -. *(motif : `^(FR[A-Z0-9]{3}E[A-Z0-9]+)$` ; unique)*

**`id_pdc_local`** · string · facultatif

Identifiant du point de recharge dans les systèmes du producteur de données. Sert de clé de rapprochement entre le fichier publié et ces systèmes. Laisser vide plutôt que d'y recopier id_pdc_itinerance.

**`puissance_nominale_kw`** · number · obligatoire · AFIR B6

Puissance maximale en kW que peut recevoir un véhicule connecté au point de recharge, déterminée en prenant en compte les capacités techniques propres du point, la puissance souscrite au réseau de distribution et les caractéristiques de l'installation comme le câblage par exemple, mais sans prendre en compte ni les limitations du connecteur ni celles du véhicule. La puissance totale que la station peut fournir simultanément est décrite par puissance_maximale_station_kw. *(≥ 2.3 ; ≤ 1000 ; unité : kW)*

**`nb_connecteurs`** · integer · obligatoire · AFIR B2

Nombre de connecteurs (prises) présents sur le point de recharge, tous types confondus. Un point de recharge peut porter plusieurs connecteurs, mais un seul peut être utilisé à la fois : deux connecteurs utilisables simultanément constituent deux points de recharge distincts. Les types de connecteurs disponibles sont décrits par les colonnes prise_type_*, sans détail par connecteur individuel : un point de recharge équipé de deux connecteurs CCS aura par exemple prise_type_combo_ccs à "true" et nb_connecteurs à 2. Un connecteur double (par exemple tête combinée CHAdeMO + T2) compte pour 2 connecteurs. Un connecteur partagé entre deux points de recharge est compté sur chacun des deux points. Cette valeur doit être supérieure ou égale au nombre de types déclarés, c'est-à-dire aux colonnes prise_type_* valant "true" augmentées des éléments de prise_type_autre. *(≥ 1)*

**`prise_type_ef`** · boolean · obligatoire · AFIR B3

Disponibilité d'une prise de type E/F sur le point de recharge. Indiquer "true" si vrai, "false" si faux.

**`prise_type_2`** · boolean · obligatoire · AFIR B3

Disponibilité d'une prise de type 2, appelée « catégorie 2 » par le règlement, sur le point de recharge. Indiquer "true" si vrai, "false" si faux.

**`prise_type_combo_ccs`** · boolean · obligatoire · AFIR B3

Disponibilité d'une prise de type Combo / CCS sur le point de recharge. Indiquer "true" si vrai, "false" si faux.

**`prise_type_chademo`** · boolean · obligatoire · AFIR B3

Disponibilité d'une prise de type Chademo sur le point de recharge. Indiquer "true" si vrai, "false" si faux.

**`prise_type_mcs`** · boolean · obligatoire · AFIR B3

Disponibilité d'une prise de type MCS (Megawatt Charging System) sur le point de recharge. Indiquer "true" si vrai, "false" si faux.

**`prise_type_autre`** · array · obligatoire · AFIR B3

Types de prises présents sur le point de recharge et non couverts par les colonnes prise_type_ef, prise_type_2, prise_type_combo_ccs, prise_type_chademo et prise_type_mcs. Liste, au format JSON (guillemets doubles), de chaînes libres nommant chaque type ; il est possible de reprendre les jetons de l'énumération ConnectorType du standard OCPI 2.2.1, par exemple IEC_62196_T3C, IEC_62196_T1, CHAOJI ou GBT_DC. Indiquer une liste vide [] si aucun autre type n'est présent.

**`courant_ac`** · boolean · obligatoire · AFIR B4

Capacité du point de recharge à délivrer du courant alternatif (AC), via au moins un de ses connecteurs. Indiquer "true" si vrai, "false" si faux. Au moins un des deux champs courant_ac et courant_dc doit valoir "true".

**`courant_dc`** · boolean · obligatoire · AFIR B4

Capacité du point de recharge à délivrer du courant continu (DC), via au moins un de ses connecteurs. Indiquer "true" si vrai, "false" si faux. Au moins un des deux champs courant_ac et courant_dc doit valoir "true".

**`plug_and_charge`** · boolean · facultatif · AFIR B8

Disponibilité de la fonctionnalité « Plug & Charge » sur le point de recharge : authentification automatique du véhicule au branchement du câble, sans badge, application ni carte. Indiquer "true" si la fonctionnalité est disponible, "false" uniquement si elle est effectivement absente. Laisser vide si l'information n'est pas connue (ne pas indiquer "false" par défaut).

**`recharge_intelligente`** · array · facultatif · AFIR B9

Services de recharge intelligente disponibles sur le point de recharge. Liste, au format JSON (guillemets doubles), des services parmi : remote (suivi et contrôle de la recharge à distance), preferences (configuration des préférences de l'utilisateur pour l'optimisation de la puissance), bidirectionnel (recharge bidirectionnelle). Les autres services sont décrits par recharge_intelligente_autre. *(éléments parmi : `remote`, `preferences`, `bidirectionnel`)*

**`recharge_intelligente_autre`** · array · facultatif · AFIR B9

Autres services de recharge intelligente disponibles sur le point de recharge et ne figurant pas dans recharge_intelligente. Liste, au format JSON (guillemets doubles), de chaînes libres nommant chaque service.

**`gratuit`** · boolean · facultatif

Gratuité de la recharge. Indiquer "true" uniquement si la recharge est gratuite en permanence, sans condition d'accès ni de durée. Dans tous les autres cas — gratuité partielle, conditionnelle, ou limitée dans le temps — indiquer "false" et décrire les conditions dans le fichier tarifaire (voir tarif_ids).

**`paiement_cb`** · boolean · facultatif · AFIR A20

Possibilité de payer par carte bancaire insérée dans le terminal. Indiquer "true" si ce moyen est présent, "false" uniquement s'il est effectivement absent. Laisser vide si l'information n'est pas connue. Le paiement sans contact est décrit par cb_sans_contact.

**`cb_sans_contact`** · boolean · facultatif · AFIR A21

Possibilité de payer par carte bancaire sans contact (NFC). Indiquer "true" si ce moyen est présent, "false" uniquement s'il est effectivement absent. Laisser vide si l'information n'est pas connue. Le paiement par carte insérée est décrit par paiement_cb.

**`paiement_ad_hoc`** · array · facultatif · AFIR A22

Options de paiement à l'acte acceptées au point de recharge, hors carte bancaire. Liste, au format JSON (guillemets doubles), parmi : qr_dynamique (code QR généré pour la recharge en cours), site_web (paiement sur un site web, par exemple depuis un code QR fixe), liquide (espèces). La liste vaut déclaration complète : [] signifie qu'aucune de ces options n'est acceptée, une cellule vide que l'information n'est pas connue. Autres options dans paiement_ad_hoc_autre, paiement par carte dans paiement_cb et cb_sans_contact. *(éléments parmi : `qr_dynamique`, `site_web`, `liquide`)*

**`paiement_ad_hoc_autre`** · array · facultatif · AFIR A22

Autres options de paiement à l'acte, absentes de paiement_ad_hoc. Liste, au format JSON (guillemets doubles), de chaînes libres.

**`complement_paiement`** · array · facultatif · AFIR A23

Informations complémentaires au sujet des prestataires de services de paiement acceptés pour le paiement à l'acte : nom d'un prestataire, ou précision utile à son sujet. Liste, au format JSON (guillemets doubles), de chaînes libres. Les options de paiement elles-mêmes sont décrites par paiement_ad_hoc, les fournisseurs de services de mobilité par emsp.

**`abonnement`** · boolean · facultatif · AFIR A24

Possibilité de payer la recharge dans le cadre d'un contrat ou d'un abonnement souscrit auprès d'un fournisseur de services de mobilité. Indiquer "true" si ce mode de paiement est possible, "false" uniquement s'il est effectivement impossible. Laisser vide si l'information n'est pas connue (ne pas indiquer "false" par défaut). Les fournisseurs acceptés sont listés par emsp.

**`tarif_ids`** · array · facultatif

Liste des identifiants de tarifs applicables au point de recharge. Plusieurs tarifs peuvent être déclarés si leurs périodes de validité ne se chevauchent pas (start_date_time, end_date_time), ce qui permet d'annoncer un tarif à venir ; à un instant donné, un seul tarif s'applique. L'ordre de la liste ne porte aucune priorité. Chaque identifiant débute par FR suivi du trigramme AFIREV de l'opérateur qui gère la tarification (CPO) et de T, suivis d'un suffixe libre. Voir le fichier tarifaire détaillé pour la description complète. *(motif des éléments : `^FR[A-Z0-9]{3}T\S+$`)*

**`reservation`** · boolean · obligatoire

Possibilité de réservation à l'avance d'un point de recharge. Indiquer "true" si vrai, "false" si faux.

**`accessibilite_pmr`** · string · obligatoire

Accessibilité du point de recharge aux personnes à mobilité réduite. Dans le cas d'un point de recharge signalisé et réservé PMR, indiquer "Réservé PMR". Dans le cas d'une point de recharge non réservé PMR mais accessible PMR, indiquer "Accessible mais non réservé PMR". Dans le cas d'un point de recharge non accessible PMR, indiquer "Non accessible". En dernier recours, si l'information n'est pas connue, indiquer "Accessibilité inconnue" ; cette valeur est destinée à disparaître, elle ne doit pas être utilisée par défaut. *(valeurs : `Réservé PMR`, `Accessible mais non réservé PMR`, `Non accessible`, `Accessibilité inconnue`)*

**`date_mise_en_service`** · date · facultatif

Date de mise en service du point de recharge.

**`horodatage_maj`** · datetime · obligatoire

Date et heure (UTC) de dernière mise à jour des données de la ligne, c'est-à-dire du point de recharge : chaque pdc d'une même station peut porter un horodatage différent. Un producteur ne disposant que d'une date peut publier T00:00:00Z. Correspond au champ last_updated de l'objet EVSE de la spécification OCPI.

## B. Champs du fichier dynamique

Clé primaire : `id_pdc_itinerance`. 9 champs.

### Point de recharge (9 champs)

**`id_pdc_itinerance`** · string · obligatoire

L'identifiant du point de recharge, tel qu'apparaissant dans le schéma statique. Doit permettre de faire le lien entre le dynamique et le statique. *(motif : `^(FR[A-Z0-9]{3}E[A-Z0-9]+)$`)*

**`etat_pdc`** · string · obligatoire · AFIR F1

`etat_pdc` caractérise l’état de fonctionnement du point de recharge : est-il en service ou hors service ? Indiquer ‘hors_service’ uniquement en cas de problème technique ou de travaux de maintenance : un point reste ‘en_service’ en dehors des horaires d’ouverture de la station, décrits par le champ horaires du fichier statique. En l’absence d’information, etat_pdc sera égal à ‘inconnu’. *(valeurs : `en_service`, `hors_service`, `inconnu`)*

**`occupation_pdc`** · string · obligatoire · AFIR F2

`occupation_pdc` caractérise l’occupation du point de recharge : est-il libre, occupé ou réservé ? Ce champ ne décrit que l’occupation : un point non occupé est ‘libre’ même en dehors des horaires d’ouverture de la station ou lorsque etat_pdc vaut ‘hors_service’. En l’absence d’information, occupation_pdc sera égal à ‘inconnu’. *(valeurs : `libre`, `occupe`, `reserve`, `inconnu`)*

**`horodatage`** · datetime · obligatoire

Indique la date et heure de remontée de l’information publiée, au format ISO 8601 UTC.

**`etat_prise_type_2`** · string · facultatif

`etat_prise_type_2` indique l’état de fonctionnement du connecteur T2 : est-il fonctionnel ou hors-service ? En l’absence d’information, indiquer ‘inconnu’. En l’absence de connecteur de ce type sur le point de recharge, laisser une chaîne de caractère vide. *(valeurs : `fonctionnel`, `hors_service`, `inconnu`)*

**`etat_prise_type_combo_ccs`** · string · facultatif

`etat_prise_type_combo_ccs` indique l’état de fonctionnement du connecteur Combo CCS : est-il fonctionnel ou hors-service ? En l’absence d’information, indiquer ‘inconnu’. En l’absence de connecteur de ce type sur le point de recharge, laisser une chaîne de caractère vide. *(valeurs : `fonctionnel`, `hors_service`, `inconnu`)*

**`etat_prise_type_chademo`** · string · facultatif

`etat_prise_type_chademo` indique l’état de fonctionnement du connecteur Chademo : est-il fonctionnel ou hors-service ? En l’absence d’information, indiquer ‘inconnu’. En l’absence de connecteur de ce type sur le point de recharge, laisser une chaîne de caractère vide. *(valeurs : `fonctionnel`, `hors_service`, `inconnu`)*

**`etat_prise_type_ef`** · string · facultatif

`etat_prise_type_ef` indique l’état de fonctionnement du connecteur EF : est-il fonctionnel ou hors-service ? En l’absence d’information, indiquer ‘inconnu’. En l’absence de connecteur de ce type sur le point de recharge, laisser une chaîne de caractère vide. *(valeurs : `fonctionnel`, `hors_service`, `inconnu`)*

**`etat_prise_type_mcs`** · string · facultatif

`etat_prise_type_mcs` indique l’état de fonctionnement du connecteur MCS (Megawatt Charging System) : est-il fonctionnel ou hors-service ? En l’absence d’information, indiquer ‘inconnu’. En l’absence de connecteur de ce type sur le point de recharge, laisser une chaîne de caractère vide. *(valeurs : `fonctionnel`, `hors_service`, `inconnu`)*

## C. Champs du fichier tarifs

Clé primaire : `tarif_id, element_index`. 12 champs.

### Tarif (9 champs)

**`tarif_id`** · string · obligatoire

Identifiant du tarif. Cet identifiant débute par FR suivi du trigramme AFIREV de l'opérateur qui gère la tarification (CPO) et de T, suivis d'un suffixe libre choisi par le producteur (ex : identifiant OCPI interne). Ce trigramme peut différer de ceux portés par les id_pdc_itinerance des points de charge auxquels le tarif s'applique. Le préfixe garantit l'unicité globale lors de la consolidation nationale et n'a aucun rôle de portée : l'applicabilité d'un tarif aux points de charge est définie par la colonne tarif_ids du fichier statique. L'unicité du suffixe est de la responsabilité du producteur au sein de son préfixe. Plusieurs lignes peuvent partager le même tarif_id (une par élément tarifaire), à condition que leur element_index diffère : le couple (tarif_id, element_index) est unique. *(motif : `^FR[A-Z0-9]{3}T\S+$`)*

**`devise`** · string · obligatoire

Code ISO 4217 de la devise utilisée pour les prix. Seul EUR est supporté, mentionné à des fins de clarté. *(valeurs : `EUR`)*

**`horodatage_maj_tarif`** · datetime · obligatoire

Date et heure de dernière mise à jour du tarif, au format ISO 8601 UTC. Correspond au champ last_updated de l'objet Tariff de la spécification OCPI, avec un format restreint à une forme canonique : suffixe Z obligatoire, pas de fractions de seconde (un DateTime OCPI doit donc être normalisé en conséquence).

**`start_date_time`** · datetime · facultatif

Date et heure (UTC) à partir de laquelle le tarif s'applique (incluse). Absente, le tarif s'applique depuis toujours.

**`end_date_time`** · datetime · facultatif

Date et heure (UTC) à partir de laquelle le tarif ne s'applique plus (exclue). Absente, le tarif s'applique jusqu'à nouvel ordre.

**`type`** · string · obligatoire

Type de tarif au sens OCPI. Seul AD_HOC_PAYMENT est accepté : ce fichier ne déclare que les prix de la recharge ad hoc (sans contrat préalable). Les autres types de tarif OCPI — REGULAR, PROFILE_CHEAP, PROFILE_FAST et PROFILE_GREEN — sont interdits pour le moment : le prix payé par un client sous contrat ou abonnement est fixé par son fournisseur de service de mobilité et ne relève pas de cette publication. Colonne conservée pour sa valeur déclarative. *(valeurs : `AD_HOC_PAYMENT`)*

**`tax_included`** · string · obligatoire

Indique si les prix incluent les taxes (TTC). Seul YES est accepté : tous les prix doivent être exprimés TTC. *(valeurs : `YES`)*

**`min_price`** · number · facultatif

Prix minimum TTC facturé pour une session de recharge. *(≥ 0)*

**`max_price`** · number · facultatif

Prix maximum TTC facturé pour une session de recharge. *(≥ 0)*

### Élément tarifaire (3 champs)

**`element_index`** · integer · obligatoire

Index de l'élément tarifaire au sein du tarif (0-based). Permet de conserver l'ordre d'application des éléments : comme en OCPI, la sélection se fait par type de composant de prix et non par élément entier. Un élément ENERGY et un élément TIME peuvent s'appliquer en même temps, chacun étant le premier de son type dont les restrictions sont satisfaites. Le couple (tarif_id, element_index) doit être unique. *(≥ 0)*

**`restrictions`** · object · obligatoire

Objet JSON décrivant les conditions d'application de cet élément tarifaire (au sens OCPI). Objet vide {} si aucune restriction. Voir le JSON Schema associé. *(JSON Schema : `restrictions.schema.json`)*

**`price_components`** · array · obligatoire

Liste JSON des composants de prix de cet élément tarifaire (au sens OCPI). Voir le JSON Schema associé. *(JSON Schema : `price-components.schema.json`)*

## D. Correspondance avec les tableaux A, B et F d'AFIR

Référence : [annexe du règlement d'exécution (UE) 2025/655](https://eur-lex.europa.eu/legal-content/FR/TXT/HTML/?uri=CELEX:32025R0655#anx_1).

| N° | Type de données (abrégé) | Niveau AFIR | Champs v3 |
|---|---|---|---|
| A1 | Dénomination légale de l'exploitant ou du propriétaire | station | `nom_operateur` |
| A2 | Dénomination commerciale | station | `nom_enseigne` |
| A3 | Nombre de points de recharge | station | `nb_pdc` |
| A4 | Assistance en matière de services | station | `presence_borniste` |
| A5 | Numéro de téléphone du service d'assistance | station | `telephone_operateur` |
| A6 | Installations proposant des services associés | station | `equipement_afir`, `equipement_autre` |
| A7 | Localisation GNSS | station | `station_latitude`, `station_longitude` |
| A8 | Informations additionnelles sur la localisation | station | `complement_localisation` |
| A9 | Pays | station | dérivé (aucune colonne) |
| A10 | Région | station | dérivé (aucune colonne) |
| A11 | Ville ou localité | station | dérivé (aucune colonne) |
| A12 | Code postal | station | `code_postal` |
| A13 | Adresse | station | `adresse_station` |
| A14 | Heures d'ouverture | station | `horaires` |
| A15 | Fuseau horaire | station | dérivé (aucune colonne) |
| A16 | Compatibilité avec les types de véhicules | station | `type_vehicule`, `type_vehicule_autre` |
| A17 | Spécifications du véhicule permises | station | `gabarit_masse_max_t`, `gabarit_hauteur_max_m`, `gabarit_longueur_max_m`, `gabarit_largeur_max_m` |
| A18 | Nombre de places de stationnement | station | `nb_places` |
| A19 | Places réservées aux personnes handicapées | station | `nb_places_pmr` |
| A20 | Appareil de paiement avec lecteur de carte bancaire | station | `paiement_cb` |
| A21 | Dispositif de paiement sans contact | station | `cb_sans_contact` |
| A22 | Autre option de paiement ad hoc | station | `paiement_ad_hoc`, `paiement_ad_hoc_autre` |
| A23 | Prestataires de services de paiement acceptés | station | `complement_paiement` |
| A24 | Option de paiement contractuel (abonnement) | station | `abonnement` |
| B1 | Code d'identification du point de recharge | point | `id_pdc_itinerance` |
| B2 | Nombre de connecteurs | point | `nb_connecteurs` |
| B3 | Type de connecteur | point | `prise_type_ef`, `prise_type_2`, `prise_type_combo_ccs`, `prise_type_chademo`, `prise_type_mcs`, `prise_type_autre` |
| B4 | Type de courant | point | `courant_ac`, `courant_dc` |
| B5 | Puissance maximale de la station | station | `puissance_maximale_station_kw` |
| B6 | Puissance maximale du point (le JO écrit « de la station », coquille) | point | `puissance_nominale_kw` |
| B7 | Prestataires de services de mobilité (recharge contractuelle) | station | `emsp` |
| B8 | Fonction « brancher et charger » | point | `plug_and_charge` |
| B9 | Services de recharge intelligente | point | `recharge_intelligente`, `recharge_intelligente_autre` |
| B10 | Électricité 100 % renouvelable | station | `enr` |
| F1 | Statut opérationnel | point | `etat_pdc` (dynamique) |
| F2 | Disponibilité | point | `occupation_pdc` (dynamique) |
| F3 | Prix ad hoc | station | fichier tarifs, rattaché au point par `tarif_ids` |

Dérivations (`x-afir-derived` du schéma statique) :

- **A10** : Région de la station au niveau NUTS-1 : aucune colonne dédiée. La valeur est déductible de code_insee_commune, la région administrative française correspondant exactement au niveau NUTS-1 (14 codes, FR1 et FRB à FRM, FRY pour les DOM).
- **A11** : Ville ou localité de la station : aucune colonne dédiée. Le nom de la commune est déductible de code_insee_commune via le code officiel géographique de l'INSEE.
- **A15** : Fuseau horaire de la station : aucune colonne dédiée. La zone est déductible de code_insee_commune (Europe/Paris en métropole, un fuseau distinct outre-mer). Elle s'exprime comme un nom de zone IANA et non comme un décalage fixe, le décalage dépendant de l'instant considéré du fait de l'heure d'été.
- **A9** : Pays de la station : aucune colonne dédiée. Le schéma est national (countryCode FR) et la valeur est déductible de station_latitude et station_longitude ou de code_insee_commune.

## E. Sous-schémas JSON du fichier tarifs

### `restrictions.schema.json`

Conditions d'application d'un élément tarifaire. Structure calquée sur l'objet TariffRestrictions de la spécification OCPI 2.2/2.3 (https://github.com/ocpi/ocpi/blob/v2.3.0/mod_tariffs.asciidoc). Les heures, dates et jours s'entendent en heure locale de la station.

**`day_of_week`** · array · facultatif

Jours de la semaine applicables *(éléments parmi : `MONDAY`, `TUESDAY`, `WEDNESDAY`, `THURSDAY`, `FRIDAY`, `SATURDAY`, `SUNDAY`)*

**`end_date`** · string · facultatif

Date à partir de laquelle cet élément tarifaire ne s'applique plus (YYYY-MM-DD, exclue)

**`end_time`** · string · facultatif

Heure de fin d'application (HH:MM) *(motif : `^([01]\d\|2[0-3]):([0-5]\d)$`)*

**`max_current`** · number · facultatif

Courant maximal (A)

**`max_duration`** · integer · facultatif

Durée maximale de la session (secondes)

**`max_kwh`** · number · facultatif

Énergie maximale consommée (kWh)

**`max_power`** · number · facultatif

Puissance maximale (kW)

**`min_current`** · number · facultatif

Courant minimal (A)

**`min_duration`** · integer · facultatif

Durée minimale de la session (secondes)

**`min_kwh`** · number · facultatif

Énergie minimale consommée (kWh)

**`min_power`** · number · facultatif

Puissance minimale (kW)

**`reservation`** · enum · facultatif

Type de réservation applicable *(valeurs : `RESERVATION`, `RESERVATION_EXPIRES`)*

**`start_date`** · string · facultatif

Date à partir de laquelle cet élément tarifaire s'applique (YYYY-MM-DD, incluse)

**`start_time`** · string · facultatif

Heure de début d'application (HH:MM) *(motif : `^([01]\d\|2[0-3]):([0-5]\d)$`)*

### `price-components.schema.json`

Liste des composants de prix d'un élément tarifaire. Structure calquée sur l'objet PriceComponent de la spécification OCPI 2.2/2.3 (https://github.com/ocpi/ocpi/blob/v2.3.0/mod_tariffs.asciidoc). Les prix sont exprimés TTC, à la différence d'OCPI qui les définit hors taxes.

**`price`** · number · obligatoire

Prix unitaire dans l'unité du type de composant, TTC obligatoirement, dans la devise du tarif

**`step_size`** · integer · facultatif

Granularité de facturation (Wh pour ENERGY, secondes pour TIME/PARKING_TIME). Optionnel. *(≥ 1)*

**`type`** · enum · obligatoire

Type de composant de prix (OCPI TariffDimensionType) : ENERGY (énergie consommée, prix au kWh), TIME (durée pendant laquelle le véhicule charge, prix à l'heure), PARKING_TIME (durée pendant laquelle le véhicule est branché sans charger, prix à l'heure), FLAT (forfait) *(valeurs : `ENERGY`, `FLAT`, `PARKING_TIME`, `TIME`)*

## F. Contrôles déclarés (`custom_checks`)

> En cours d'affinage : ne pas les prendre au pied de la lettre (voir le document principal).

**Fichier statique**

| Contrôle | Paramètres |
|---|---|
| `valid-afirev-trigram` | column = id_pdc_itinerance |
| `valid-afirev-trigram` | column = id_station_itinerance |
| `coherence-trigram-station-pdc` | columns = id_station_itinerance, id_pdc_itinerance |
| `valid-emsp-afirev` | column = emsp |
| `coherence-coordonnees-station` | columns = id_station_itinerance, station_latitude, station_longitude |
| `suspect-connecteur-comme-pdc` | columns = id_station_itinerance, prise_type_ef, prise_type_2, prise_type_combo_ccs, prise_type_chademo, prise_type_mcs, prise_type_autre |
| `coherence-nb-connecteurs` | columns = prise_type_ef, prise_type_2, prise_type_combo_ccs, prise_type_chademo, prise_type_mcs, prise_type_autre ; count_column = nb_connecteurs |
| `coherence-courant-ac-dc` | columns = courant_ac, courant_dc |
| `siren-checksum` | column = siren_amenageur |
| `siren-online` | column = siren_amenageur |
| `opening-hours-value` | column = horaires |
| `coherence-nom-siren` | columns = nom_amenageur, siren_amenageur |
| `code-insee-exists` | column = code_insee_commune |
| `coherence-code-postal-code-insee` | columns = code_postal, code_insee_commune |
| `coherence-code-insee-coordonnees` | columns = code_insee_commune, station_latitude, station_longitude |
| `coherence-adresse-coordonnees` | columns = adresse_station, station_latitude, station_longitude |
| `foreign-key-array` | column = tarif_ids ; reference_column = tarif_id ; resource = irve-tarifs |
| `presence-tarif-adhoc` | column = tarif_ids ; resource = irve-tarifs |
| `unicite-tarif-applicable` | column = tarif_ids ; resource = irve-tarifs |
| `coherence-gratuit-tarifs` | columns = gratuit, tarif_ids |

**Fichier tarifs**

| Contrôle | Paramètres |
|---|---|
| `valid-afirev-trigram` | column = tarif_id |
| `json-schema-validation` | column = restrictions |
| `json-schema-validation` | column = price_components |
| `coherence-element-index` | columns = tarif_id, element_index |
| `coherence-tarif-denormalise` | columns = devise, horodatage_maj_tarif, start_date_time, end_date_time, type, tax_included, min_price, max_price ; group_by = tarif_id |
| `coherence-min-max-price` | max_column = max_price ; min_column = min_price |
| `coherence-start-end-date-time` | end_column = end_date_time ; start_column = start_date_time |
