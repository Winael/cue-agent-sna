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

## 4. Connaissances Acquises

Ces travaux ont permis d'acquérir une connaissance approfondie des points suivants :
- **Architecture Full-Stack :** Maîtrise de la conception d'une application web complète avec un backend API (FastAPI) et un frontend riche (React).
- **Conception d'API pour l'Analyse de Données :** Techniques pour exposer des calculs complexes (SNA) de manière performante et sémantique via une API REST.
- **Visualisation de Données Contextuelle :** Stratégies pour concevoir des interfaces qui guident l'utilisateur en adaptant la visualisation au contexte de l'analyse.
- **Gestion d'État Frontend :** Techniques avancées de gestion d'état dans React (`useState`, `useRef`) pour manipuler des vues de données multiples (graphe complet vs graphe filtré).
