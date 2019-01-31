# MyDSLAdventure
Projet réalisé par Martin Goubet, Evan Mottais et Tom Spreters dans le cadre du module d'IDM à l'INSA Rennes

Vous pouvez trouver le code source de ce projet sur github à l'adresse :  https://github.com/mgoubet/MyDSLAdventure

Structure du code
-----------------

Notre code est structuré en différents projets Eclipse.
Tout d’abord, nous avons le projet MyDslAdventure qui contient la modélisation de notre syntaxe avec le diagramme. Ce projet nous a permis de générer les projets suivants MyDslAdventure.rpg, MyDslAdventure.edit, MyDslAdventure.editor, MyDslAdventure.ide, MyDslAdventure.ui.
Le plus important est le projet MyDslAdventure.rpg qui contient notre grammaire ainsi que les générateurs du aslx et des images. Ce projet contient également le validateur qui vérifie la justesse du code écrit dans notre DSL. De plus ce projet contient également des fichiers de ressources comme la librairie CombatLib de Quest que nous utilisons pour gérer les combats entre le joueur et les monstres mais également les images par défaut que nous utilisons.
Nous avons également le projet MyDslAdventure.ui où nous avons géré le labelling et les icônes des composants de notre langage.

Comment utiliser notre langage ?
--------------------------------

Pour ce faire, il suffit de lancer une nouvelle instance d’Eclipse depuis le projet MyDslAdventure.rpg, de créer un projet et d’y ajouter un fichier .rpg. Ainsi Eclipse va détecter qu’il s’agit d’un projet Xtext et nous apporter la correction syntaxique et tous les autres outils que nous avons rajouté. 
Pour avoir la carte en direct des pièces que l’on crée, il faut sauvegarder une première version du jeu pour avoir la carte qui se génère une première fois puis l’ouvrir dans l'éditeur d’eclipse et activer l’auto-refresh de l’image. Ainsi, à chaque sauvegarde du fichier la carte sera régénérée pour s’actualiser avec le code.

Comment tester le jeu ?
-----------------------

Pour ce faire, Il faut disposer d’un ordinateur Windows ou d’une VM Windows. En effet, l'éditeur de Quest n’est disponible que sous Windows. Il faut donc installer ce dernier, en lançant le fichier .exe de Quest disponible dans le dossier Quest. Enfin, il suffit de récupérer le fichier .zip qui est généré par notre DSL, de l’extraire à l’emplacement de votre choix et de lancer le fichier .aslx avec Quest puis de cliquer sur Play.
 Si vous souhaitez, utiliser la version web de Quest, il faut quand même passer par l’éditeur sous Windows afin de publier le jeu dans un format que le site web de Quest accepte.

Liste des fichiers générés
--------------------------

Pour chaque fichier [game].rpg, le projet génère un certain nombre de fichiers dans le dossier src-gen/ du projet Eclipse courant :
* [game].aslx  :  le jeu généré pour l’éditeur Quest
* [game]_map.png : une carte du jeu avec les Rooms et connections entre celles-ci
* [game]/[room id].png : une carte décrivant la pièce de nom [room id]
* [game]/[monster id].png : idem pour le monstre [monster id]
* [game]/[weapon id].png : idem pour le monstre [weapon id]
* [game].zip : un zip de tous les fichiers générés et toutes les dépendances du jeu, prêt à être ouvert par Quest.

Exemple basique
---------------
```
"Game"  
Rooms

    Room CastleEntrance "The castle entrance"
        presentation "You can hear screams through a big door"
        exits
        	-> "You open the big door" with "open the door" goto CastleThrone
        
    Room CastleThrone "The throne room."
        presentation "There is two orcs that are eating a corpse"
        exits
        	-> "You open the door to the treasure" with "open the door" goto CastleTreasure
        	
    Room Nothing "The countryside"
        presentation "There is a castle in front of you and a forest on your left."
        exits
            -> "You are going to the castle" with "to the castle" goto CastleEntrance
            -> "You are going to the forest. There is nothing 
				so you go to the castle." with "left" goto CastleEntrance
        actions
            -> "You eat an apple" with "eat" 
            
	Room CastleTreasure "The castle treasure room"
		presentation "There is a lot of chest full of gold"

Ends in CastleTreasure

Monsters
    monster orc "A green orc" with 10 health
    attacks for 2 damage with "fist"
    put orc in CastleThrone
    put orc in CastleThrone
    give orc weapon BattleAxe
    
   
Weapons
	weapon Sword "The holy sword" attacks for 5 damage
	weapon BattleAxe "Battle axe" attacks for 4 damage
	
Player starts in Nothing with 40 health and Sword 
```

Explication du langage
----------------------

Tout d'abord le jeu doit commencer par une chaine de charactère qui correspond au nom du jeu.
Ensuite dans l'ordre de votre choix vous pouvez définir les rooms, les montres, les armes, les fins du jeu et le joueur. Il est obligatoire d'avoir une fin de jeu et un joueur.

Les rooms doivent avoir une présentation obligatoirement mais les exits et les actions ne sont pas obligatoire.

Pour définir un monstre, on lui donne un identifiant et un alias qui sera affiché lors du jeu. On définit ensuite sa vie et ses dégats. Puis on peut le placer dans la pièce de notre choix. On peut placer le même monstre à différents endroits.

Les armes sont définis simplement avec le mot clé "weapon" puis un alias et ensuite les dégats.

Pour le joueur, on doit lui donner un emplacement de départ, mais également un montant de point de vie et on peut également lui donner une arme.

Pour les fins de jeu, il suffit d'utiliser le mot clé "Ends in" puis un id de room. Pour en mettre plusieurs on peut séparer les pièce de fin par le mot clé "or".

Lors de la création d'un jeu, vous pouvez également utiliser l'autocomplétion avec ctrl+espace.