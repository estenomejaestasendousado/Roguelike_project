extends CharacterBody2D
@export_category("Variables")
var bullet_speed = 1000

#tipos de bala
enum tipos_de_bala{ NORMAL,FOGO }
var tipo_de_municao_atual = tipos_de_bala.NORMAL

@onready var coldown_tempo = $CooldownTempo
@export var em_coldown = 0
@export var coldown_maximo = 5

@export var max_life = 100
@export var em_coldown_invencibilidade = 0
@export var tempo_maximo_de_invencibilidade = 3
@onready var tempo_invencibilidade = $Invencibilidade


@export var _move_speed: float = 300.0
@export var _acceleration: float = 0.3
@export var _friction: float = 0.3

func _physics_process(_delta: float) -> void:
	_move()
	move_and_slide()
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("atirar"):
		if tipo_de_municao_atual == tipos_de_bala.NORMAL:
			_atirar()
		if em_coldown <= 0 && tipo_de_municao_atual == tipos_de_bala.FOGO: #aqui tem que ser assim, pq voce tem que atirar pelo menos uma vez
			_atirar_variacao_fogo()
			em_coldown = coldown_maximo #aqui esta a espera do coldwns
			coldown_tempo.start() #aqui estora o tempo de 1 em 1 seg
		
	if Input.is_action_just_pressed("mudar_tipo_de_bala"):
		if tipo_de_municao_atual == tipos_de_bala.NORMAL:
			tipo_de_municao_atual = tipos_de_bala.FOGO
		else:
			tipo_de_municao_atual = tipos_de_bala.NORMAL
			
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
	if tipo_de_municao_atual == tipos_de_bala.NORMAL:
		var bullet = preload("res://cenas/bullet.tscn")
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = global_position
		bullet_instance.rotation_degrees = rotation_degrees
		get_tree().get_root().call_deferred("add_child", bullet_instance)

func _atirar_variacao_fogo():
	if tipo_de_municao_atual == tipos_de_bala.FOGO:
		var bullet_fire = preload("res://cenas/bullet_fire_variation.tscn")
		var bullet_fire_instance = bullet_fire.instantiate()
		bullet_fire_instance.position = global_position
		bullet_fire_instance.rotation_degrees = rotation_degrees
		get_tree().get_root().call_deferred("add_child", bullet_fire_instance)

func _die():
	get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Inimigos"):
		if em_coldown_invencibilidade <= 0:
			print("levou dano")
			max_life -= 50
			print(max_life)
			if max_life <= 0:	
				_die()
		tempo_invencibilidade.start()
		em_coldown_invencibilidade = tempo_maximo_de_invencibilidade
		

func _on_cooldown_tempo_timeout() -> void:
	em_coldown -= 1 #aqui vai igualar até 0 e depois receber o 5 dnv
	print("Não pode atirar")
	if em_coldown == 0:
		print("pode atirar")
		coldown_tempo.stop()

func _on_invencibilidade_timeout_ivencibilidade() -> void:
	em_coldown_invencibilidade -= 1
	print("Invencivel")
	if em_coldown_invencibilidade == 0:
		print("fim da invencibilidade")
		tempo_invencibilidade.stop()
