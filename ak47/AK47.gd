extends Spatial

var x_rot = rotation.x

onready var gunfire = get_node("Fire_gun")
onready var emptyclip = get_node("Empty_clip")
onready var reloadsound = get_node("Reload")
onready var model_animator = get_node("ModelAnimator")
onready var camera_animator = get_node("CameraAnimator")
onready var raycast = get_node("Model/RayCast")
onready var bullet_counter = get_node("Bullet_counter")

var bullets = 30
var focused = false

func shoot():
	if not reloadsound.playing:
		if bullets > 0:
			if not model_animator.is_playing():
				bullets -= 1
				update_counter()
				gunfire.play()
				if raycast.is_colliding():
					var target = raycast.get_collider()
					if target.is_in_group("Enemies"):
						target.hit(raycast.get_collision_normal())
				if focused:
					model_animator.play("Focused_fire")
				else:
					model_animator.play("Fire_gun")
		else:
			if not emptyclip.playing:
				emptyclip.play()

func update_counter():
	bullet_counter.text = "%s/30" % bullets

func reload():
	if not reloadsound.playing and not model_animator.is_playing():
		model_animator.play("Reload_gun")
		reloadsound.play()
		bullets = 30
		update_counter()
		
func is_scoped():
	return get_node("FPS_camera").current
	
func is_focused():
	return focused
		
func focus(on):
	if on:
		camera_animator.play("Focus")
		focused = true
	else:
		camera_animator.play_backwards("Focus")
		focused = false

func reset_rotation():
	rotation.x = x_rot
		
func _input(event):
	if event is InputEventMouseMotion and is_scoped():
		var movement = event.relative
		var sensitivity = 0.1
		rotation.x -= deg2rad(movement.y * sensitivity) #*cos(rotation.z)
		#rotation.y -= deg2rad(movement.x * sensitivity)

func _ready():
	pass
