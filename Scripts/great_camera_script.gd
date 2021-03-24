extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

var mouse_sens = 0.3
var camera_anglev=0

func _input(event):         
	if event is InputEventMouseMotion:
		self.rotate_y(deg2rad(-event.relative.x*mouse_sens))
		rotation.x +=  (deg2rad(-event.relative.y*mouse_sens))
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
const speed = 60
func _process(delta):
	if Input.is_action_pressed("camera_forward"):
		translation -= transform.basis.z*delta*speed
		
	if Input.is_action_pressed("camera_backward"):
		translation += transform.basis.z*delta*speed

	if Input.is_action_pressed("camera_left"):
		translation -= transform.basis.x*delta*speed

	if Input.is_action_pressed("camera_right"):
		translation += transform.basis.x*delta*speed
	
	if Input.is_action_pressed("camera_up"):
		translation += transform.basis.y*delta*speed
		
	if Input.is_action_pressed("camera_down"):
		translation -= transform.basis.y*delta*speed


