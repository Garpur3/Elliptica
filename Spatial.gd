extends Spatial



var p_id = 0
var gman = GMan.new()
var planets = []
func _ready():
	# var planet_template = preload("res://Planet.tscn")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for node in get_node('.').get_children():
		if node.is_in_group("planets"):
			gman.add_planet(p_id, 20 + 10*p_id, node.transform.origin)
			planets.append(node)
			p_id += 1
	
	# var R = 100
	# for _i in range(100):
	# 	var theta1 = rng.randf_range(0, 2*PI)
	# 	var theta2 = rng.randf_range(0, PI)
	# 	var x = cos(theta1)*sin(theta2)*R
	# 	var z = sin(theta1)*sin(theta2)*R
	# 	var y = cos(theta2)*R
	# 	var planet = planet_template.instance()
	# 	planet.translation = Vector3(x,y,z)
		
	# 	gman.add_planet(p_id, 20, Vector3(x,y,z))
	# 	planets.append(planet)
	# 	p_id += 1
		
	# 	add_child(planet)



func _process(delta):
	for i in range(p_id):
		gman.set_planet_location(i, planets[i].translation)
		var force = gman.force_of(i)
		planets[i].apply_central_impulse(-0.003*delta*force)
