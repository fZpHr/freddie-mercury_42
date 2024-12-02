extends MeshInstance3D  # Utilise MeshInstance3D pour la porte

@export var open_height: float = 5.0  # Hauteur à laquelle la porte s'ouvrira
@export var speed: float = 2.0  # Vitesse d'animation
var is_open: bool = false  # État de la porte (ouverte ou fermée)
var initial_position: Vector3 = Vector3()
var target_position: Vector3 = Vector3()
var tween: Tween  # Variable pour le Tween

# Fonction appelée à l'initialisation
func _ready():
	# Enregistre la position initiale de la porte
	initial_position = global_transform.origin
	# Crée le Tween et ajoute-le à la scène
	tween = Tween.new()
	add_child(tween)

# Ouvre la porte
func open_door():
	if not is_open:
		target_position = initial_position + Vector3(0, open_height, 0)  # Définir la position cible pour l'ouverture
		tween.tween_property(self, "global_transform/origin", target_position, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		is_open = true

# Ferme la porte
func close_door():
	if is_open:
		target_position = initial_position  # Retour à la position initiale
		tween.tween_property(self, "global_transform/origin", target_position, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		is_open = false

# Gère l'entrée de l'utilisateur (touche "Espace" ou "Entrée" pour ouvrir/fermer)
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Exemple de touche "Entrée" ou "Espace"
		if is_open:
			close_door()
		else:
			open_door()
