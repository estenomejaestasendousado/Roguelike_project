extends CharacterBody2D

var bullet_speed = 1000

var bullet = preload("res://cenas/bullet.tscn")
var bullet_fire = preload("res://cenas/bullet_fire_variation.tscn")

var max_life = 100

@export_category("Variables")
@export var _move_speed: float = 300.0

@export var _acceleration: float = 0.3
@export var _friction: float = 0.3
func _physics_process(_delta: float) -> void:
	_move()
	move_and_slide()
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("atirar"):
		_atirar()
	if Input.is_action_just_pressed("mudar_tipo_de_bala"):
		_atirar_variacao_fogo()
	
func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("esquerda", "direita"),
		Input.get_axis("cima", "baixo")
	)
	
	if _direction != Vector2.ZERO:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return	
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)


func _atirar():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position
	bullet_instance.rotation_degrees = rotation_degrees
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func _atirar_variacao_fogo():
	var bullet_fire_instance = bullet_fire.instantiate()
	bullet_fire_instance.position = global_position
	bullet_fire_instance.rotation_degrees = rotation_degrees
	get_tree().get_root().call_deferred("add_child", bullet_fire_instance)



func _die():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigos"):
		print("levou dano")
		max_life -= 50
		if max_life <= 0:	
			_die()
