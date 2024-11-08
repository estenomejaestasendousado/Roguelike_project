extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Area2D/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var porta: StaticBody2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.connect("body_entered", Callable(self, "_on_body_entered"))
	collision_layer = 1 << 9  # Camada da porta
	collision_mask = 1 << 1   # Máscara para detectar o Player
func _on_body_entered(body: Node2D) -> void: 
	if body.is_in_group("Player"): 
		if body.chave: 
			abrir_porta() 
		else: 
			print("As chaves não foram coletadas")
	
		if body.chave_easter_egg:
			abrir_porta()
		else:
			print("Sem chave")
func abrir_porta() -> void: 
	animated_sprite_2d.play("porta_abrindo") 
	porta.queue_free() # Desativa a colisão print("Porta aberta")
