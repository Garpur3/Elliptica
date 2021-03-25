extends Camera

onready var fps_camera = get_parent().get_node("AK 47/FPS_camera")

func aim_down_sights(zoom_in):
	if zoom_in:
		fps_camera.make_current()
	else:
		self.make_current()
		
func _ready():
	pass
