extends Spatial



var p_id = 0
var gman = GMan.new()
var planets = []
var objects = []

func _ready():
	var steroid_template = preload("res://Steroid.tscn")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for node in get_children():
		if node.is_in_group("planets"):
			node.id = p_id
			gman.add_planet(p_id, node.mass, node.transform.origin, Vector3(0, 0, 0))
			planets.append(node)
			p_id += 1
	
	gman.set_planet_velocity(1, Vector3(0, 0, 100))
	gman.set_planet_velocity(2, Vector3(50, 0, 0))
	
	# g = 2   ;   1 = 0,0,12   ;   2 = 8,0,0     ;    range = 12-16
	
	
	gman.set_G(0.02)
	
	var R = 16000
	
	for i in range(2500):
		var theta = rng.randf_range(0, 2*PI)
		var asteroid = steroid_template.instance()
		asteroid.translation = Vector3(cos(theta) * R, rng.randf_range(-400, 400), sin(theta) * R)
		asteroid.scale *= rng.randf_range(0.5, 2)
		var speed = asteroid.translation.normalized().cross(Vector3(0, 1, 0)) * rng.randf_range(12, 16) + Vector3(0, rng.randf_range(-1, 1), 0)
		gman.add_object(i, 0, asteroid.translation, speed)
		add_child(asteroid)
		objects.append(asteroid)

func _process(delta):
	gman.update(delta*1)
	for i in range(planets.size()):
		planets[i].translation = gman.get_planet_location(i)
	for i in range(objects.size()):
		objects[i].translation = gman.get_object_location(i)

onready var planet = get_node("Planet")

func fix_angle(trans):
	var planet_vector = (trans.origin - planet.transform.origin).normalized()
	trans.basis.y = planet_vector
	trans.basis.z = trans.basis.y.rotated(trans.basis.x, deg2rad(90))
	trans.basis.x = trans.basis.y.cross(trans.basis.z)
	trans = trans.orthonormalized()
	return trans
