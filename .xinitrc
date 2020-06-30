#!/bin/sh

######################################################
##                        X                         ##
##                                                  ##
##   ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗  ##
##  ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝  ##
##  ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗ ##
##  ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║ ##
##  ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝ ##
##   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ##
##                                                  ##
##                                     ~/.xinitrc   ##
######################################################

# Déclaration des variables
userFeh=$HOME/.fehbg
userResources=$HOME/.Xresources
userModmap=$HOME/.Xmodmap
sysResources=/etc/X11/xinit/.Xresources
sysModmap=/etc/X11/xinit/.Xmodmap

# Fonction pour utiliser les ressources systèmes ou utilisateur
startXresources () {
	# Contrôle présence des fichiers Xresources et Xmodmap
	if [ -f $sysResources ]; then
		xrdb -merge $sysResources
	fi

	if [ -f $sysModmap ]; then
		xrdb -merge $sysModmap
	fi

	if [ -f $userResources ]; then
		xrdb -merge $userResources
	fi

	if [ -f $userModmap ]; then
		xrdb -merge $userModmap
	fi
}

# Fonction initialisation pour lancer le contenu du répertoire /etc/X11/xinit/xinitrc.d
startInit () {
	# Contrôle présence répertoire /etc/X11/xinit/xinitrc.d et execute son contenu
	if [ -d /etc/X11/xinit/xinitrc.d ] ; then
		for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
			[ -x "$f" ] && . "$f"
		done
		unset f
	fi
}

# Fonction pour afficher le fond d'écran
startFeh () {
	# Contrôle présence fichier fehbg
	if [ -f $userFeh ]; then
		~/.fehbg &
	fi
}

# Fonction pour démarrer les programmes communs
startCmPrgs () {
	# Vérouiller le pavé numérique
	numlockx &

	# Démarrer la composition graphique
	compton &

	# Démarrer la bar des tâches
	polybar example &

	# Démarrer la notification
	dunst &

	# Executer la fonction pour le fond d'écran
	startFeh
}

# Fonction de lancement du gestionnaire de fenêtres bspwm
startBspwm () {
	exec bspwm
}

# Executer la fonction des ressources
startXresources

# Executer la fonction d'initialisation du contenu des scripts X11
startInit

# Executer la fonction des programmes communs
startCmPrgs

# Executer le gestionnaire de fenêtres bspwm
startBspwm
