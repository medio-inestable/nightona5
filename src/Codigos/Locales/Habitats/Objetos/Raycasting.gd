extends RayCast

onready var carroElegido = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if $RayCast.get_collider(RigidBody):
				carroElegido = $RayCast.get_collider(RigidBody)
				carroElegido.get_node(Camera) == true

