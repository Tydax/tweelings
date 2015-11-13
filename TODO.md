### TODO list

## Général
* Refonte de la structure du projet : subdiviser en modules ? (Database, Business, Views)
* Création de namespaces via les modules (rejoint la tâche ci-dessus)
* Mieux comprendre Ruby en général afin de correctement structurer l’application…
* Écriture des routes Sinatra (donc réfléchir à la structure du projet) (utilisation de wildcards pour faire des appels automatiques aux fonctions ?)
* Ajouter des lignes de debug !!
* Ajouter un module général encapsulant toute l'application

## Database
* Implémenter la numérotation de lignes dans les fichiers .csv
* Implémenter la suppression de ligne(s) dans les fichiers .csv
* Implémenter le repérage de doublons
* Utiliser SQLite pour se simplifier GRANDEMENT la vie

## Algorithmes
* Implémentation d’un algorithme naïf en utilisant un dictionnaire de mots clés : Mots+ & Mots-
* Implémentation de la première méthode utilisation la notion de distance (KNN)

## Fonctionnalités
* Lier ensemble les classes afin d’arriver à une application fonctionnelle et structurée
* Implémenter l’utilisation/configuration d’un proxy

## Vues
* Écriture de classe(s) Ruby d'interaction avec l’interface graphique
    * Appel d'autres classes/méthodes Ruby lors d’un appel Ajax
    * Retour avec production de JSON/YAML/gaufre/brouette/etc afin de notifier l’interface graphique)

## Interface
* Écriture des scripts JavaScript d'interaction avec les classes Ruby
* Ajout des éléments d'interface nécessaires :
    * Critère de recherche
    * Choix d'algorithmes pour les résultats
    * (+) Popup avec barre de progression avec information sur l’avancement en utilisant les retours Ajax pour notifier l’interface graphique de l’avancée ?
    * Onglet de configuration du proxy

## Documentation
* Compléter et l’écrire proprement en suivant des conventions (YARD serait super !! (basé sur RDoc mais propose des tas de tags utiles semblables à JavaDoc !!))