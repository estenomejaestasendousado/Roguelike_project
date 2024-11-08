extends CharacterBody2D

var bullet_speed = 2000
@export var _move_speed: float = 1000
@export var _acceleration: float = 0.3
@export var _friction: float = 0.3

const DASH_SPEED = 750  # Velocidade do dash
const DASH_DURATION = 0.5  # Duração do dash em segundos
var dashing = false
var can_dash = true
var dash_cooldown = 1.5  # Tempo de espera antes de poder usar o dash novamente
var dash_time = 0.0  # Tempo que o dash está ativo

func _ready() -> void:
	add_to_group("ecir")

func _physics_process(_delta: float) -> void:
	_move()
	move_and_slide()
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true	
		can_dash = false
		dash_time = DASH_DURATION
	
	if dashing:
		velocity = velocity.normalized() * DASH_SPEED
		dash_time -= _delta  # Decrementa o tempo do dash
		if dash_time <= 0:
			dashing = false
			velocity = Vector2.ZERO  # Para o movimento ao final do dash
			
	# Lógica de cooldown
	if not dashing and not can_dash:
		dash_cooldown -= _delta
		if dash_cooldown <= 0:
			can_dash = true
			dash_cooldown = 1.0  # Resetar o cooldown
			
	if Input.is_action_pressed("atirar"):
		_atirar()

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
	var bullet = preload("res://cenas/bullet.tscn")
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = global_position
	bullet_instance.rotation = (get_global_mouse_position() - global_position).angle()
	bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(bullet_instance.rotation)  # Define a velocidade na direção da rotação
	get_tree().get_root().call_deferred("add_child", bullet_instance)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
