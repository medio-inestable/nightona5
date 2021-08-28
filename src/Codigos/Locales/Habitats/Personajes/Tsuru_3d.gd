extends Spatial

export var visible_cull = false

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	if visible_cull:
		$Llantas.set_layer_mask_bit(0, true)
		$Tsuru.set_layer_mask_bit(0, true)		
		$Llantas.set_layer_mask_bit(1, false)
		$Tsuru.set_layer_mask_bit(1, false)
	pass
