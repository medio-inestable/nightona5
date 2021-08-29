extends Spatial

onready var camara = $CSGBox/Camera
onready var ball = $Cajita
onready var car_mesh = $CSGBox
onready var ground_ray = $CSGBox/RayCast

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -0.5, 0)
# Engine power
export(float) var acceleration = 50
# Turn amount, in degrees
export(float) var steering = 21.0
# How quickly the car turns
export(float) var turn_speed = 5
# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75

# Variables for input values
var speed_input = 0
var rotate_input = 0
var fov_input = 0
var fov_true = 0

var body_tilt = -50



func _ready():
#	camara.current = true
	ground_ray.add_exception(ball)

func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
	
func _process(delta):
	# Can't steer/accelerate when in the air
#	if not ground_ray.is_colliding():		
#		return	
		
		
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
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		print(ball.linear_velocity.length()*0.006)
		camara_shake(ball.linear_velocity.length())
		camara.fov = (ball.linear_velocity.length()*0.7) + 70
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
