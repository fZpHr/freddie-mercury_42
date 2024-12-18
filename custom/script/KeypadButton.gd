extends Interactable
@export var number = "0"
var interaction_text = "Press keypad button"
signal on_interact

func _ready():
	if not Engine.is_editor_hint():
		var area = $Area3D
		if area:
			area.collision_layer = 0
			area.collision_mask = 0b0000_0000_0000_0010_0000_0000_0000_0000  # Layer 18 (player-hands)
			
			area.body_entered.connect(_on_body_entered)
			area.body_exited.connect(_on_body_exited)
			print("Configuration Area3D complète pour le bouton ", number)

func _on_body_entered(body: Node3D):
	if body is XRToolsCollisionHand:
		print("Main XR entrée dans la zone du bouton ", number)
		print("Bouton pressé:", number)
		emit_signal("on_interact", number)

func _on_body_exited(body: Node3D):
	if body is XRToolsCollisionHand:
		print("Main XR sortie de la zone du bouton ", number)

func set_number(value):
	number = value
	if value:
		$"../../SubViewport/PasswordViewport/PasswordLabel".text = str(value)

func get_interaction_text():
	return interaction_text
