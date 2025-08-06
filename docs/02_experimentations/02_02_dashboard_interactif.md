# Fiche d'Expérimentation : Développement du Dashboard Interactif

**Période :** Août 2025

**Objectif :** Développer une interface de visualisation interactive pour l'exploration d'un graphe organisationnel complexe. L'objectif était de permettre une analyse visuelle des données issues du modèle CUE, en offrant des fonctionnalités telles que la sélection de nœuds/relations, la coloration sémantique et la manipulation directe du graphe.

## 1. Contexte et Verrous Technologiques

Le développement de ce dashboard a nécessité de surmonter plusieurs verrous technologiques liés à l'intégration de bibliothèques de visualisation modernes (Sigma.js v3) dans un écosystème React, ainsi qu'à la gestion de la synchronisation entre un modèle de données asynchrone et le cycle de vie du rendu d'un composant.

Les principaux défis étaient :
- **Incertitude de l'API :** La version récente de Sigma.js a introduit des changements majeurs dans son API, rendant la documentation existante obsolète et créant une incertitude sur la méthode correcte d'intégration et de manipulation du graphe.
- **Gestion du Rendu WebGL :** La prévention d'artefacts visuels (images "fantômes") lors des interactions (zoom, déplacement) dans un contexte de rendu WebGL.
- **Synchronisation Asynchrone :** La gestion d'une "race condition" entre le chargement des données du graphe (`fetch`) et l'initialisation du composant de rendu.
- **Modélisation des Événements :** L'implémentation d'interactions complexes (glisser-déposer, clics sur les arêtes) qui ne sont pas gérées nativement par le DOM mais par la couche d'abstraction de la bibliothèque.

## 2. Démarche Expérimentale et Itérations

Pour lever ces verrous, une démarche itérative et expérimentale a été adoptée.

### 2.1. Intégration et Stabilisation de la Bibliothèque de Graphe

- **Problématique :** Des erreurs de compilation initiales ont démontré une incompatibilité avec notre approche d'import.
- **Expérimentation :** Plusieurs stratégies d'importation ont été testées. La recherche a révélé que la gestion de la structure de données du graphe avait été découplée dans une bibliothèque dépendante (`graphology`).
- **Solution :** Le code a été restructuré pour utiliser `graphology` pour la manipulation des données et `sigma` uniquement pour le rendu, stabilisant ainsi la base technique.

### 2.2. Résolution des Artefacts de Rendu

- **Problématique :** Des "images fantômes" du graphe persistaient lors du zoom, indiquant un problème de nettoyage du canvas WebGL entre les frames.
- **Expérimentation :** Le cycle de vie du composant React a été analysé. L'hypothèse était que l'instance de Sigma n'était pas correctement détruite et recréée lors des mises à jour.
- **Solution :** Le code a été refactorisé pour garantir que l'instance de Sigma soit systématiquement "tuée" (`kill()`) et les ressources libérées avant chaque nouveau rendu, en particulier lors du re-chargement des données.

### 2.3. Implémentation des Interactions Utilisateur

- **Problématique :** Le clic sur les arêtes et le glisser-déposer des nœuds n'étaient pas fonctionnels par défaut.
- **Expérimentation :** L'API événementielle de Sigma.js a été explorée. Il a été découvert que, par optimisation, les événements sur les arêtes étaient désactivés. Pour le glisser-déposer, il a fallu intercepter et traduire les coordonnées de la souris de l'espace du viewport vers l'espace du graphe.
- **Solution :** Le paramètre `enableEdgeEvents` a été activé. Une logique spécifique a été implémentée pour gérer les états `downNode`, `draggedNode` et `mouseup`, en mappant les coordonnées de la souris pour permettre une manipulation fluide.

## 3. Connaissances Acquises

Ces travaux ont permis d'acquérir une connaissance approfondie des points suivants :
- **Architecture de Sigma.js v3 :** Maîtrise de la séparation entre la gestion des données (`graphology`) et le rendu (`sigma`), ainsi que du système de "programmes" de rendu.
- **Gestion du Cycle de Vie en React :** Techniques avancées pour synchroniser des bibliothèques tierces manipulant directement le DOM (ou un canvas) avec le cycle de vie de React (`useEffect`), en particulier la gestion du nettoyage pour éviter les fuites de mémoire et les artefacts visuels.
- **Système Événementiel WebGL :** Compréhension et manipulation de systèmes d'événements de bas niveau qui opèrent en dehors du DOM standard, et leur intégration dans une application React.

Ces développements ont abouti à la création d'un outil d'analyse visuelle robuste et performant, essentiel à l'atteinte des objectifs globaux du projet de recherche.
