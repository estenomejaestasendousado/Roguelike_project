extends CharacterBody2D

var movimento = Vector2()

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("Player")
	position += (Player.position - position)/50
	look_at(Player.position)
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Bullet" in body.name:
		queue_free()
		
