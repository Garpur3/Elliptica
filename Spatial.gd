extends Spatial



var p_id = 2
var gman = GMan.new()
var planets = []
func _ready():
	var planet_template = preload("res://Planet.tscn")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var planet1 = get_node('Planet')
	var planet2 = get_node('Planet2')

	gman.add_planet(0, 30000, planet1.transform.origin)
	gman.add_planet(1, 300, planet2.transform.origin)
	planets.append(planet1)
	planets.append(planet2)
	planet2.apply_central_impulse(Vector3(0, 0, 8000))

	# for node in get_node('.').get_children():
	# 	if node.is_in_group("planets"):
	# 		gman.add_planet(p_id, 20, node.transform.origin)
	# 		planets.append(node)
	# 		p_id += 1
	
	# var R = 100
	# for _i in range(50):
	# 	var theta1 = rng.randf_range(0, 2*PI)
	# 	var theta2 = rng.randf_range(0, PI)
	# 	var x = cos(theta1)*sin(theta2)*R
	# 	var z = sin(theta1)*sin(theta2)*R
	# 	var y = cos(theta2)*R
	# 	var planet = planet_template.instance()
	# 	planet.translation = Vector3(x,y,z)
		
	# 	gman.add_planet(p_id, rng.randf_range(10,20), Vector3(x,y,z))
	# 	planets.append(planet)
	# 	p_id += 1
		
	# 	add_child(planet)



func _process(delta):
	for i in range(planets.size()):
		gman.set_planet_location(i, planets[i].translation)
		var force = gman.force_of(i)
		planets[i].apply_central_impulse(-0.2*delta*force)

onready var planet = get_node("Planet")

func fix_angle(trans):
	var planet_vector = (trans.origin - planet.transform.origin).normalized()
	trans.basis.y = planet_vector
	trans.basis.z = trans.basis.y.rotated(trans.basis.x, deg2rad(90))
	trans.basis.x = trans.basis.y.cross(trans.basis.z)
	trans = trans.orthonormalized()
	return trans
