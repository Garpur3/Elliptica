extends KinematicBody

const move_force = 30
const jump_force = 200

var gravity = Vector3.DOWN
var velocity = Vector3()

#onready var planet = get_parent().get_node("Planet")
onready var camera1 = get_node("Camera")
onready var gun1 = get_node("AK 47")

var home_planet
var flying = true
	

onready var main = get_parent()
	
func fix_angle(planet):
	var planet_vector = (transform.origin - planet.transform.origin).normalized()
	transform.basis.y = planet_vector
	transform.basis.z = transform.basis.y.rotated(transform.basis.x, deg2rad(90))
	transform.basis.x = transform.basis.y.cross(transform.basis.z)
	transform = transform.orthonormalized()
	
	
func _physics_process(delta):
	resolve_input(delta)
	
	
	
	var collision = move_and_collide(velocity * delta, false)
	
		
	if collision:
		#velocity *= pow((0.995),(1/delta))#nuningur
		fix_angle(collision.collider)
		home_planet = collision.collider
		flying = false
		
	if !flying:
		var offset_factor = transform.origin.distance_to(home_planet.transform.origin) - home_planet.get_node("MeshInstance").scale.x
		print(offset_factor)
		move_and_slide(transform.origin.direction_to(home_planet.transform.origin) * offset_factor * 0.5)
		fix_angle(home_planet)

	
var rdy = false
func resolve_input(delta):
	if not rdy:
		main.add_object(self, 1, Vector3.ZERO)
		rdy = true

	var speed = 100
	
	if Input.is_action_pressed("m_forward"):
		velocity -= transform.basis.z*delta*speed
		
	if Input.is_action_pressed("m_backward"):
		velocity += transform.basis.z*delta*speed

	if Input.is_action_pressed("m_left"):
		velocity -= transform.basis.x*delta*speed

	if Input.is_action_pressed("m_right"):
		velocity += transform.basis.x*delta*speed
	if Input.is_action_pressed("fly"):
		flying = true
	
	if flying:
		if Input.is_action_pressed("m_up"):
			velocity += transform.basis.y*delta*speed
			
		if Input.is_action_pressed("m_down"):
			velocity -= transform.basis.y*delta*speed
		
		
	#jump:
	#if Input.is_action_just_pressed("m_jump"):
		#velocity += jump_force* global_transform.basis.y

	if Input.is_action_just_pressed("aim"):
		gun1.get_node("FPS_camera").make_current()
		get_node("Companion_bot").visible = false
	if Input.is_action_just_released("aim"):
		get_node("Companion_bot").visible = true
		gun1.reset_rotation()
		camera1.make_current()
	if Input.is_action_just_pressed("focus"):
		gun1.focus(true)
	if Input.is_action_just_released("focus"):
		gun1.focus(false)
	if Input.is_action_pressed("fire"):
		gun1.shoot()
	if Input.is_action_just_pressed("reload"):
		gun1.reload()
	if Input.is_action_pressed("close"):
		get_tree().quit()
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative
		var sensitivity = 0.2
		if not camera1.current:
			sensitivity = 0.1
		transform.basis = transform.basis.rotated(transform.basis.y, deg2rad(-movement.x * sensitivity))
		#transform.basis = transform.basis.rotated(transform.basis.x, deg2rad(-movement.y * 0.2))
		#rotation.x -= deg2rad(movement.y * 0.2)*cos(rotation.z)
		#rotation.z -= deg2rad(movement.y * 0.2)*sin(rotation.y)
