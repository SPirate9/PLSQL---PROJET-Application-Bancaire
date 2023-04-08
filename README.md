# PLSQL_PROJET_BD

PROJET Application Bancaire de gestion de comptes

Ce projet porte sur la mise en exploitation de la partie serveur d’une application de gestion de comptes
bancaires. Une IHM cliente de gestion de compte a été développée par une entreprise prestataire (hors
cadre du projet). Ce travail consiste à mettre en place tous les composants du serveur ORACLE (les
tables, les Packages et les vues) pour que cette IHM cliente puisse interagir avec la base de données. Le
schéma fonctionnel général de l’application est le suivant :

![Capture d’écran 2023-04-08 à 12 47 05](https://user-images.githubusercontent.com/118197355/230717094-e5cdbda5-a29d-4ced-8451-df7bbe9277f0.png)

Pour réaliser cette application, un découpage par lot des tâches est proposé :
 [ Lot 1 ] (myLib/Projet_Lot1 .sql) : Mise en place des tables de production (myLib/README.md)
 Lot 2 : Mise en place du package
 Lot 3 : Mise en place du trigger de calcul de solde
 Compléments : Mise en place des Vues
