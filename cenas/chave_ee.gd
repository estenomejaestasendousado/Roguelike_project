extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 1<<8
	collision_mask = 1<<1
	animated_sprite_2d.play("chave")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._obter_chaves_easter_egg()
		call_deferred("queue_free")
