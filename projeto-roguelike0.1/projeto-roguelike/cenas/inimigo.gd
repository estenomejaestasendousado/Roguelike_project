extends CharacterBody2D

var movimento = Vector2()
var max_vida = 150


func _ready() -> void:
	add_to_group("Inimigos")
func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("Player")
	position += (Player.position - position)/50
	look_at(Player.position)
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		print(max_vida)
		max_vida -= 20
		if max_vida <= 0:	
			queue_free()
	
	if body.is_in_group("Bullet Fire"):
		_debuff(max_vida)
		
func _debuff(valor_vida):
	if valor_vida != 0:
		while valor_vida > 0:
			valor_vida -= 5
			print(valor_vida)
			if valor_vida <= 0:
				queue_free()
	
	
