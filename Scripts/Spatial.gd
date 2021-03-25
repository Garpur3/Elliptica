extends Spatial

onready var gman = GMan.new()
onready var rng = RandomNumberGenerator.new()

var p_id = 0
var planets = []

var o_id = 0
var objects = []

func add_object(obj, mass, velocity):
	objects.append(obj)
	gman.add_object(o_id, mass, obj.translation, velocity)
	o_id += 1
	return o_id-1

func _ready():
	OS.window_fullscreen = true
	var steroid_template = preload("res://Steroid.tscn")
	rng.randomize()
	
	for node in get_children():
		if node.is_in_group("planets"):
			node.id = p_id
			gman.add_planet(p_id, node.mass, node.transform.origin, Vector3(0, 0, 0))
			planets.append(node)
			p_id += 1
	
	gman.set_planet_velocity(1, Vector3(0, 0, 20))
	gman.set_planet_velocity(2, Vector3(0.8, 0, 0))
	
	# g = 2   ;   1 = 0,0,12   ;   2 = 8,0,0     ;    range = 12-16
	
	
	gman.set_G(0.02)
	
	var R = 16000
	
	for i in range(2500):
		var theta = rng.randf_range(0, 2*PI)
		var asteroid = steroid_template.instance()
		asteroid.translation = Vector3(cos(theta) * R, rng.randf_range(-400, 400), sin(theta) * R)
		var speed = asteroid.translation.normalized().cross(Vector3(0, 1, 0)) * rng.randf_range(1.2, 1.6) + Vector3(0, rng.randf_range(-1, 1), 0)
		
		add_object(asteroid, 1, speed)
		#gman.add_object(i, 1, asteroid.translation, speed)
		add_child(asteroid)
		#objects.append(asteroid)

func _process(delta):
	delta *= 0.01 
	gman.update(delta)
	for i in range(planets.size()):
		planets[i].translation = gman.get_planet_location(i)
	for i in range(objects.size()):
		if objects[i] == get_node("Player"):
			gman.set_object_location(i, get_node("Player").translation)
			get_node("Player").velocity += gman.force_of_object(i)*delta
		else:
			objects[i].translation = gman.get_object_location(i)
