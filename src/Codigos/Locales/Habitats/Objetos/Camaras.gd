extends Spatial

export(NodePath) onready var camara_1 = get_node(camara_1) as Camera
export(NodePath) onready var camara_2 = get_node(camara_2) as Camera
export(NodePath) onready var camara_3 = get_node(camara_3) as Camera
export(NodePath) onready var camara_4 = get_node(camara_4) as Camera

var camaras = []
export(int, "Camara_1", "Camara_2", "Camara_3", "Camara_4") var camara_actual

func _ready():	
	camaras = [camara_1, camara_2, camara_3, camara_4]
	
	for camara in camaras:
		camara.current = false
	
	camaras[camara_actual].current = true

func _input(event):
	if Input.is_action_just_pressed("cambia_camara"):
		for camara in camaras:
			camara.current = false
		camara_actual = (camara_actual + 1) % 4
		camaras[camara_actual].current = true
		
		Senales.emit_signal("cambia_camara")
