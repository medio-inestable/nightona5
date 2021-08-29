extends Spatial

onready var camara = $CameraC2

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			camara.current = true
		if event.button_index == BUTTON_LEFT and event.pressed == false:
			print("Left Mouse Button Released")
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			print("Right Mouse Button Clicked")
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			print("Right Mouse Button Released")
		if event.button_index == BUTTON_MIDDLE and event.pressed == true:
			print("Middle Mouse Button Clicked")
		if event.button_index == BUTTON_MIDDLE and event.pressed == false:
			print("Middle Mouse Button Released")
		if event.button_index == BUTTON_LEFT and event.doubleclick == true:
			print("Left Mouse Button Double Clicked")
