extends Camera2D

@export var zoom_increment = 0.1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	if event.is_action_pressed("zoom_out"):
		zoom_out()

func zoom_in(): 
	zoom = Vector2(zoom.x - zoom_increment, zoom.y - zoom_increment) 
	# Limitar o zoom para evitar zoom extremo 
	if zoom.x < 0.1: 
		zoom = Vector2(0.1, 0.1)

func zoom_out(): 
	zoom = Vector2(zoom.x + zoom_increment, zoom.y + zoom_increment) 
	# Limitar o zoom para evitar zoom extremo 
	if zoom.x > 2: 
		zoom = Vector2(2, 2)
