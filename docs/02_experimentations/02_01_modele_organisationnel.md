# Modèle d'Organisation Actuel

Ce document décrit l'organisation telle que modélisée dans les fichiers CUE du répertoire `cue/`.

Le modèle est structuré de manière hiérarchique et inclut les entités suivantes :

## 1. Chaîne de Valeur (`#ValueChain`)
Représente un flux de valeur de bout en bout au sein de l'organisation. C'est le niveau le plus élevé de l'organisation modélisée.

- **Attributs :**
    - `name`: Nom de la chaîne de valeur (ex: "Product Development").

## 2. Portefeuille (`#Portfolio`)
Un ensemble de programmes et de projets qui soutiennent une chaîne de valeur spécifique. Il est lié à une `#ValueChain`.

- **Attributs :**
    - `name`: Nom du portefeuille (ex: "Digital Transformation").
    - `valueChain`: Référence à la chaîne de valeur à laquelle il appartient.
    - `okrNames`: Liste des noms des OKRs associés à ce portefeuille.

## 3. Train SAFe (`#SAFeTrain`)
Un Agile Release Train (ART) dans le cadre SAFe. Il appartient à un `#Portfolio`.

- **Attributs :**
    - `name`: Nom du train SAFe (ex: "Agile Release Train 1").
    - `portfolio`: Référence au portefeuille auquel il appartient.
    - `okrNames`: Liste des noms des OKRs associés à ce train SAFe.

## 4. Équipe (`#Team`)
Une équipe de développement agile. Chaque équipe appartient à un `#SAFeTrain`.

- **Attributs :**
    - `name`: Nom de l'équipe (ex: "Team Phoenix").
    - `type`: Type d'équipe (ex: "feature team", "platform team").
    - `train`: Référence au train SAFe auquel elle appartient.
    - `memberNames`: Liste des noms des membres de l'équipe.
    - `artifactNames`: Liste des noms des artefacts dont l'équipe est propriétaire.
    - `okrNames`: Liste des noms des OKRs associés à cette équipe.

## 5. Membre (`#Member`)
Représente un individu au sein de l'organisation.

- **Attributs :**
    - `name`: Nom du membre (ex: "Alice").
    - `role`: Rôle du membre (ex: "Product Owner", "Developer").
    - `skills`: Liste des compétences du membre.
    - `seniority`: Niveau de séniorité (entier de 1 à 3).
    - `workload`: Charge de travail (nombre entre 0 et 1).
    - `manager`: Nom du manager direct du membre (peut être `null`).
    - `contract`: Type de contrat ("CDI", "ESN", "Freelance").
    - `available`: Disponibilité du membre.
    - `tenureMonths`: Ancienneté en mois.
    - `location`: Lieu de travail.
    - `language`: Langues parlées.
    - `active`: Statut du membre.
    - `team`: Nom de l'équipe à laquelle le membre appartient.
    - `communities`: Liste des communautés de pratique auxquelles le membre participe.
    - `pairedWith`: Liste de relations de pair-programming.
    - `mentors`: Liste de relations de mentorat.
    - `blockedBy`: Liste de relations de blocage.
    - `askAdviceFrom`: Liste de relations de demande de conseil.
    - `talksTo`: Liste de relations de communication.


## 6. Artefact (`#Artifact`)
Représente un livrable technique (service, application, bibliothèque).

- **Attributs :**
    - `name`: Nom de l'artefact (ex: "UserService").
    - `type`: Type de l'artefact ("service", "application", "library").
    - `dependsOn`: Liste des noms des artefacts dont cet artefact dépend.

## 7. Rituel (`#Ritual`)
Représente une réunion ou un événement récurrent au sein de l'organisation.

- **Attributs :**
    - `name`: Nom du rituel (ex: "Phoenix Daily").
    - `type`: Type de rituel (ex: "Daily Scrum", "PI Planning").
    - `frequency`: Fréquence du rituel (ex: "daily", "weekly").
    - `participants`: Liste des noms des membres participant à ce rituel.

## 8. OKR (`#OKR`)
Représente un Objectif et ses Key Results associés.

- **Attributs :**
    - `objective`: L'objectif principal.
    - `keyResults`: Liste des résultats clés mesurables.
    - `owner`: Nom de l'entité (Portefeuille, Train SAFe, Équipe) propriétaire de cet OKR.

## 9. Communauté de Pratique (`#CommunityOfPractice`)
Un groupe de personnes qui partagent un intérêt pour un sujet.

- **Attributs :**
    - `name`: Nom de la communauté.
    - `topic`: Sujet de la communauté.
    - `facilitator`: Nom du facilitateur.
    - `communityRelations`: Liste des relations spécifiques à la communauté.

## 10. Relation (`#Relation` et `#CommunityRelation`)
Définit une relation entre deux membres. `#CommunityRelation` est une spécialisation pour les relations au sein d'une communauté.

- **Attributs (`#Relation`):**
    - `target`: Cible de la relation.
    - `weight`: Poids de la relation (0 à 1).
    - `startDate`: Date de début de la relation.
    - `channel`: Canal de communication.
    - `context`: Contexte de la relation.
- **Attributs (`#CommunityRelation`):**
    - `source`: Source de la relation.
    - `target`: Cible de la relation.
    - `type`: Type de relation ("mentors", "collaborates", etc.).
    - `context`: Contexte spécifique à la communauté.


## Relations Modélisées

Le modèle CUE établit des relations claires entre ces entités :
- Un `Portfolio` appartient à une `ValueChain`.
- Un `SAFeTrain` appartient à un `Portfolio`.
- Une `Team` appartient à un `SAFeTrain`.
- Les `Team`s sont composées de `Member`s.
- Les `Member`s peuvent faire partie de `CommunityOfPractice`.
- Les `Member`s ont des relations explicites entre eux (`pairedWith`, `mentors`, etc.).
- Les `Team`s sont propriétaires d'`Artifact`s.
- Les `Artifact`s peuvent avoir des dépendances entre eux.
- Les `Member`s peuvent avoir un `manager` (qui est aussi un `#Member`).
- Les `Ritual`s ont des `participants` qui sont des `#Member`s.
- Les `OKR`s sont la propriété de `Portfolio`s, `SAFeTrain`s ou `Team`s.

Cette modélisation permet une représentation structurée et validable de l'organisation, servant de base à l'analyse de réseau social et à la simulation par agents IA.