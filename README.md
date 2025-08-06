# Modélisation Déclarative d’Organisations et Analyse Relationnelle par Agents IA

Ce projet explore une solution innovante pour modéliser et simuler le fonctionnement d'organisations complexes, à la croisée de la **modélisation déclarative (CUElang)**, de l’**analyse des réseaux sociaux (SNA)** et de l’**intelligence artificielle agentique (LangGraph + LLM)**.

## Objectif

Le but est de démontrer qu’il est possible de :
- Formaliser les structures sociales d'une organisation de façon typée, modulaire et validable avec CUElang.
- Projeter ces structures dans un graphe d’analyse pour en déduire des métriques (centralité, cliques, dépendances, etc.).
- Y adjoindre des agents IA spécialisés qui proposent, simulent, analysent et restructurent l'organisation de manière semi-autonome.
- Créer une boucle de rétroaction entre l'analyse, la modélisation et l'itération dans un cadre déclaratif cohérent.

## Contexte Scientifique

Ce projet s'inscrit au croisement de plusieurs disciplines :
- Sciences du travail (modélisation des interactions réelles, zones d’incertitude, habitus).
- Ingénierie des systèmes complexes.
- Représentation déclarative et validation de contraintes (CUE).
- Intelligence artificielle réflexive (LLM en graphe avec LangGraph).
- Analyse de graphe (SNA).

## Installation

1.  **Prérequis :** Assurez-vous d'avoir [Homebrew](https://brew.sh/) installé sur macOS.
2.  **Installer CUE :**
    ```bash
    brew install cue
    ```
3.  **Créer l'environnement virtuel et installer les dépendances Python :**
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```

## Utilisation

### 1. Modélisation de l'organisation avec CUE

Le cœur de la modélisation organisationnelle se trouve dans le fichier `cue/model.cue`. Ce fichier définit la structure de l'organisation, incluant les chaînes de valeur, portefeuilles, trains SAFe, équipes, membres, artefacts, rituels et OKRs.

Pour valider le modèle CUE et visualiser sa structure en JSON :

```bash
cue eval cue/model.cue
```

### 2. Génération et Visualisation du Graphe d'Organisation

Le script Python `src/build_graph.py` permet de transformer le modèle CUE en un graphe de réseau social NetworkX et de le visualiser.

Pour générer le graphe (le fichier `org_graph.png` sera créé à la racine du projet) :

```bash
source venv/bin/activate
python -m src.build_graph
```

### 3. Analyse du Graphe

Le script Python `src/analyze_graph.py` permet de calculer et d'afficher des métriques d'analyse de réseaux sociaux (SNA) à partir du graphe d'organisation.

Pour exécuter l'analyse du graphe :

```bash
source venv/bin/activate
python -m src.analyze_graph
```

### 4. Dashboard Interactif

Un dashboard interactif est disponible pour explorer le graphe de l'organisation. Pour le lancer :

```bash
cd dashboard
npm install
npm start
```

Le dashboard permet de visualiser le graphe, de zoomer, de déplacer les noeuds, et d'afficher les détails des noeuds et des relations en cliquant dessus.

### 5. Agents IA et Simulation (À venir)

*(Instructions pour l'utilisation des agents IA avec LangGraph pour la simulation et la restructuration organisationnelle seront ajoutées ici.)*
