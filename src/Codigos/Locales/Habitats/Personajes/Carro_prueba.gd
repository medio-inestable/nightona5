extends Spatial

onready var camara_interior = $Tsuru/Control/ViewportContainer/Viewport/Camera_interior
onready var camara_exterior = $Tsuru/Camera_exterior
onready var ball = $Cajita
onready var car_mesh = $Tsuru
onready var ground_ray = $Tsuru/RayCast
onready var velocimetro = $Tsuru/Control/velocimetro
onready var tsurucarcasa = $Tsuru_carcasa


# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -0.5, 0)
var bump_offset = Vector3(0, -0.5, 3.513)
# Engine power
export(float) var acceleration = 50
# Turn amount, in degrees
export(float) var steering = 21.0
# How quickly the car turns
export(float) var turn_speed = 5
# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75

export var peso_colliders_player = 15
export var peso_colliders_npc = 15

# Variables for input values
var speed_input = 0
var rotate_input = 0
var fov_input = 0
var fov_true = 0

var body_tilt = -50

export var carro_seleccionado = false

var collision_force

func _ready():
#	camara.current = true
	ground_ray.add_exception(ball)
	if not carro_seleccionado:
#		ball.queue_free()
		camara_exterior.current = false	
		camara_interior.current = false
		velocimetro.queue_free()
		$Tsuru_carcasa/cola/TsuruPLACEHOLDER.visible = true			
	else:
		$Tsuru_carcasa/cola/TsuruPLACEHOLDER.visible = false
		

func _integrate_forces(state : PhysicsDirectBodyState)->void:
	print(collision_force)
	collision_force = Vector3.ZERO
	for i in range(state.get_contact_count()):
		collision_force += state.get_contact_impulse(i) * state.get_contact_local_normal(i)
#		ball.add_central_force(collision_force)
		print(collision_force)

func _physics_process(_delta):
	

	# Accelerate based on car's forward direction
	if not carro_seleccionado:		
		car_mesh.transform.origin = ball.transform.origin + sphere_offset
		tsurucarcasa.transform.origin = ball.transform.origin + sphere_offset
		
		ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
		$Tsuru_carcasa/cola.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
		
		return
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	tsurucarcasa.transform.origin = ball.transform.origin + sphere_offset
	
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	$Tsuru_carcasa/cola.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
	
func _process(delta):
		
	if not carro_seleccionado:
		speed_input = 0	
		speed_input += 0.2
		speed_input *= acceleration
		return	
		
		
	# Get accelerate/brake input
	speed_input = 0
	
	speed_input += Input.get_action_strength("acelera")
	
	
	speed_input -= Input.get_action_strength("frena")*0.0001
	speed_input *= acceleration


	
#	camara.fov = speed_input
#	print(camara.fov)
	
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("izq")
	rotate_input -= Input.get_action_strength("der")
	rotate_input *= deg2rad(steering)
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		tsurucarcasa.global_transform.basis = tsurucarcasa.global_transform.basis.slerp(new_basis, turn_speed * delta)
		tsurucarcasa.global_transform = tsurucarcasa.global_transform.orthonormalized()
		
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		camara_shake(ball.linear_velocity.length()*2)
		velocimetro.text = String(floor(ball.linear_velocity.length()*1.3))
		camara_exterior.fov = (ball.linear_velocity.length()*0.7) + 70
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, (1 - ball.linear_velocity.length() * 0.006) * (10 * delta))

		
		
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func camara_shake(cantidad):
	var rshake = rand_range(0, 1)
	camara.rotation_degrees = Vector3(0,0,cantidad*rshake*0.015)


func _on_Cajita_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			camara.current = true
		if event.button_index == BUTTON_LEFT and event.pressed == false:
			print("Left Mouse Button Released")
