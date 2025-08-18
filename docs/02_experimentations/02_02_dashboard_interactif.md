# Fiche d'Expérimentation : Développement du Dashboard Interactif

**Période :** Août 2025

**Objectif :** Développer une interface de visualisation interactive pour l'exploration d'un graphe organisationnel complexe, en y intégrant des outils d'analyse et un annuaire des membres.

## 1. Contexte et Verrous Technologiques

Le développement de ce dashboard a nécessité de surmonter plusieurs verrous technologiques liés à l'intégration de bibliothèques de visualisation modernes (Sigma.js v3) dans un écosystème React, ainsi qu'à la gestion de la synchronisation entre un modèle de données asynchrone et le cycle de vie du rendu d'un composant.

## 2. Démarche Expérimentale et Itérations

### 2.1. Intégration et Stabilisation de la Bibliothèque de Graphe
- **Problématique :** Des erreurs de compilation initiales et des artefacts visuels ("images fantômes") lors du zoom.
- **Solution :** Restructuration du code pour utiliser `graphology` pour la manipulation des données et `sigma` pour le rendu. L'instance de Sigma est désormais systématiquement détruite (`kill()`) avant chaque nouveau rendu pour éviter les fuites de mémoire et les artefacts.

### 2.2. Implémentation des Interactions Utilisateur
- **Problématique :** Le clic sur les arêtes et le glisser-déposer des nœuds n'étaient pas fonctionnels par défaut.
- **Solution :** Activation du paramètre `enableEdgeEvents` et implémentation d'une logique spécifique pour gérer les états `downNode`, `draggedNode` et `mouseup`, en mappant les coordonnées de la souris pour permettre une manipulation fluide.

### 2.3. Correction de bugs de rendu
- **Problématique :** Le graphe ne s'affichait plus suite à une mise à jour du backend.
- **Solution :** L'erreur provenait d'une incohérence entre les données envoyées par le backend et celles attendues par le frontend. La propriété contenant la relation d'un lien (edge) était nommée `label` dans le JSON du backend, mais le frontend tentait d'accéder à `edge.relation`. La correction du code frontend pour utiliser `edge.label` a résolu le problème de rendu.

## 3. Intégration du Backend et des Fonctionnalités d'Analyse

### 3.1. Intégration du Backend FastAPI
Pour passer d'une approche basée sur des fichiers JSON statiques à une gestion dynamique, un backend a été implémenté avec FastAPI.
- **Architecture :** Le backend (`backend/main.py`) expose des endpoints API (`/api/graph_data`, `/api/directory_data`) et sert directement le frontend React, éliminant le besoin d'un proxy.
- **Génération Dynamique :** Les données sont générées à la volée à partir du modèle CUE. Le backend surveille le répertoire `cue/` et recharge automatiquement le graphe lors de modifications.

### 3.2. Implémentation des Analyses SNA Interactives
- **Problématique :** Comment permettre à un utilisateur, potentiellement non-spécialiste, de lancer et de comprendre des analyses SNA complexes ?
- **Expérimentation :** Une API REST a été conçue avec FastAPI, exposant chaque métrique SNA via un endpoint acceptant un paramètre `?node_type=...` pour des analyses contextuelles.
- **Solution :** Un panneau de contrôle a été implémenté en React.
    - **Boutons d'Action :** Chaque bouton correspond à une analyse pré-configurée (ex: "Centralité d'Intermédiarité (Membres)").
    - **Visualisation Dynamique :** Au clic, le frontend appelle l'API et redessine le graphe pour n'afficher que le sous-graphe pertinent (ex: uniquement les membres), avec une visualisation adaptée (taille/couleur des nœuds).
    - **Panneau Pédagogique :** Un panneau de résultats s'affiche, expliquant la métrique et présentant les données clés, rendant l'analyse interprétable.
    - **Reset :** Un bouton "Reset" permet de revenir à la vue globale de l'organisation.

### 3.3. Ajout de l'Annuaire des Membres
En complément de la visualisation graphique, un onglet "Annuaire" a été ajouté au dashboard. Cet onglet permet de consulter une liste détaillée des membres de l'organisation, avec leurs attributs (rôle, équipe, compétences, etc.). Cette fonctionnalité offre une vue tabulaire et facilement consultable des données organisationnelles.

### 3.4. Vue Membre et Analyse de Voisinage
- **Problématique :** Comment permettre une analyse fine des relations d'un membre spécifique ?
- **Expérimentation :** De nouvelles routes API ont été ajoutées au backend (`/api/member_subgraph/{member_id}`, `/api/sna/shortest_path`, `/api/sna/ranked_neighbors`) pour fournir des données ciblées sur un membre.
- **Solution :** Le frontend a été enrichi pour exploiter ces nouvelles routes :
    - **Vue isolée :** En cliquant sur un membre, un bouton "Isoler les relations directes" permet de n'afficher que ce membre et ses voisins immédiats.
    - **Chemin le plus court :** Un autre bouton permet de sélectionner un second membre et de visualiser le chemin le plus court entre eux dans le graphe.
    - **Analyse des voisins :** Une fonctionnalité permet de classer les voisins d'un membre par ordre de centralité, offrant un aperçu rapide des relations les plus importantes.

### 3.5. Système de Filtrage Interactif
- **Problématique :** Comment permettre aux utilisateurs de cibler des sous-ensembles spécifiques de l'organisation pour l'analyse ou la consultation ?
- **Expérimentation :** Implémentation d'un système de filtrage dynamique basé sur les attributs des membres.
- **Solution :**
    - **Backend (`backend/main.py`) :**
        - Ajout d'un endpoint `/api/filter_options` pour récupérer la liste des valeurs uniques pour chaque critère de filtrage (rôles, lieux, compétences, contrats, langues).
        - Modification de l'endpoint `/api/directory_data` pour accepter des paramètres de filtrage, permettant de renvoyer uniquement les membres correspondant aux critères sélectionnés.
    - **Frontend (`dashboard/src/`) :**
        - Création d'un nouveau composant `Filter.js` pour gérer l'interface utilisateur des filtres.
        - Intégration du composant `Filter` dans `App.js`, positionné au-dessus des vues du graphe et de l'annuaire.
        - Utilisation de menus déroulants à sélections multiples (`react-select`) pour une expérience utilisateur intuitive.
        - Mise à jour de `Directory.js` pour appeler l'API avec les filtres sélectionnés.
        - Mise à jour de `Graph.js` pour masquer les nœuds qui ne correspondent pas aux critères de filtrage, permettant une visualisation ciblée sans altérer la structure sous-jacente du graphe.
        - Ajustements CSS (`App.css`) pour assurer un affichage horizontal des filtres avec défilement si nécessaire.

### 3.6. Nouvelles Requêtes SNA pour le Diagnostic Agile/DevOps
- **Problématique :** Comment fournir des insights plus spécifiques pour l'amélioration des pratiques Agile et DevOps au sein de l'organisation ?
- **Expérimentation :** Développement de requêtes SNA ciblées basées sur des problématiques courantes en transformation Agile et DevOps.
- **Solution :**
    - **Backend (`src/analyze_graph.py`, `backend/main.py`) :**
        - Implémentation de la fonction `get_knowledge_sharing_communities` pour détecter les silos de connaissance basés sur les relations explicites de partage de connaissance (mentorat, pair-programming, etc.).
        - Ajout de l'endpoint `/api/sna/knowledge_silos` pour exposer cette analyse.
        - Implémentation de l'endpoint `/api/sna/dependency_bottlenecks` pour l'identification des goulots d'étranglement sur les dépendances d'artefacts.
        - Utilisation des endpoints existants de centralité (`degree_centrality`, `betweenness_centrality`) pour l'analyse de la communication.
    - **Frontend (`dashboard/src/Graph.js`) :**
        - Ajout de nouvelles options d'analyse dans le panneau SNA pour déclencher ces requêtes.
        - Adaptation de l'affichage des résultats pour les communautés de connaissance (similaire à la détection de communautés existante).

## 4. Connaissances Acquises

Ces travaux ont permis d'acquérir une connaissance approfondie des points suivants :
- **Architecture Full-Stack :** Maîtrise de la conception d'une application web complète avec un backend API (FastAPI) et un frontend riche (React).
- **Conception d'API pour l'Analyse de Données :** Techniques pour exposer des calculs complexes (SNA) de manière performante et sémantique via une API REST.
- **Visualisation de Données Contextuelle :** Stratégies pour concevoir des interfaces qui guident l'utilisateur en adaptant la visualisation au contexte de l'analyse.
- **Gestion d'État Frontend :** Techniques avancées de gestion d'état dans React (`useState`, `useRef`) pour manipuler des vues de données multiples (graphe complet vs graphe filtré).
