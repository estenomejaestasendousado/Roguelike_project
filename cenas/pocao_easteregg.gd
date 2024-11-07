extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	collision_layer = 1<<8
	collision_mask = 1<<1
	animated_sprite_2d.play("pocao")
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var next_scene = preload("res://cenas/fase_ee.tscn")
		get_tree().change_scene_to_packed(next_scene)  # Corrigido 'next_scen	e' para 'next_scene'
		print("Fase dois carregada")
		call_deferred("queue_free")
	if body.is_in_group("ecir"):
		var next_scene = preload("res://cenas/fase_um.tscn")
		get_tree().change_scene_to_packed(next_scene)  # Corrigido 'next_scen	e' para 'next_scene'
		print("Fase dois carregada")
		call_deferred("queue_free")
