extends CharacterBody2D
@export_category("Variables")
var bullet_speed = 2000

var num_de_chaves = 0
var chave = false

#tipos de bala
enum tipos_de_bala{ NORMAL,FOGO }
var tipo_de_municao_atual = tipos_de_bala.NORMAL

@onready var animacao = $AnimatedSprite2D
@onready var heathlbar = $ProgressBar
@onready var escudobar = $Escudo
@onready var tocha_luz = $tocha

var energia_maxima = 1.0
var energia_inicial = 1.0

@onready var coldown_tempo = $CooldownTempo
@export var em_coldown = 0
@export var coldown_maximo = 2

var vida = 100
var vida_total = 100

var vida_escudo = 0
var max_escudo = 50

@export var em_coldown_invencibilidade = 0
@export var tempo_maximo_de_invencibilidade = 3
@onready var tempo_invencibilidade = $Invencibilidade

const DASH_SPEED = 750  # Velocidade do dash
const DASH_DURATION = 0.5  # Duração do dash em segundos
var dashing = false
var can_dash = true
var dash_cooldown = 1.5  # Tempo de espera antes de poder usar o dash novamente
var dash_time = 0.0  # Tempo que o dash está ativo

@export var _move_speed: float = 300.0
@export var _acceleration: float = 0.3
@export var _friction: float = 0.3


func _ready() -> void:
	tocha_luz.energy = energia_inicial
	set_process(true)
	add_to_group("Player")
	heathlbar.value = vida
	collision_layer = 1 << 1
	collision_mask = (1 << 0) | (1 << 1) | (1 << 2) | (1 << 4) | (1 << 5) | (1 << 6) | (1 << 9)
	
func _physics_process(_delta: float) -> void:
	_move()
	move_and_slide()
	_perder_tocha(0.1 * _delta)
	
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
			
	if Input.is_action_just_pressed("atirar"):
		if tipo_de_municao_atual == tipos_de_bala.NORMAL:
			animacao.play("atirar_cima")
			_atirar()
			animacao.stop()
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
		
		if _direction.x > 0:
			animacao.play("andar_direita")
		if _direction.x < 0:
			animacao.play("andar_esquerda")
		if _direction.y > 0:
			animacao.play("andar_baixo")
		if _direction.y < 0:
			animacao.play("andar_cima")
	
		return	
	animacao.play("idle_baixo")
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

func _atirar():
	if tipo_de_municao_atual == tipos_de_bala.NORMAL:
		var bullet = preload("res://cenas/bullet.tscn")
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = global_position
		bullet_instance.rotation = (get_global_mouse_position() - global_position).angle()
		bullet_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(bullet_instance.rotation)  # Define a velocidade na direção da rotação
		get_tree().get_root().call_deferred("add_child", bullet_instance)
		animacao.play('atirar_baixo')

func _atirar_variacao_fogo():
	if tipo_de_municao_atual == tipos_de_bala.FOGO:
		var bullet_fire = preload("res://cenas/bullet_fire_variation.tscn")
		var bullet_fire_instance = bullet_fire.instantiate()
		bullet_fire_instance.position = global_position
		bullet_fire_instance.rotation = (get_global_mouse_position() - global_position).angle()
		bullet_fire_instance.linear_velocity = Vector2(bullet_speed, 0).rotated(bullet_fire_instance.rotation)  # Define a velocidade na direção da rotação
		get_tree().get_root().call_deferred("add_child", bullet_fire_instance)
		animacao.play('atirar_baixo')

func recuperar_vida(valor):
	vida += valor
	if vida > vida_total:
		vida = vida_total
	heathlbar.value = vida
	print("vida do jogador:", vida)

func recuparar_escudo(valor):
	vida_escudo += valor
	if vida_escudo > max_escudo:
		vida_escudo = max_escudo
	escudobar.value = vida_escudo
	print("Escudo: ", vida_escudo)
	
func _recuperar_tocha(valor):
	tocha_luz.energy += valor
	if tocha_luz.energy > energia_maxima:
		tocha_luz.energy = energia_inicial

func _perder_tocha(valor):
	if tocha_luz.energy > 0:
		tocha_luz.energy = float(max(0, tocha_luz.energy - valor))
		print("perdendo tocha", tocha_luz.energy)

func _obter_chaves():
	if num_de_chaves == 3:	
		chave = true
		print("Cahves coletadas")

func _die():
	get_tree().call_deferred("reload_current_scene")
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	heathlbar.value = vida
	escudobar.value = vida_escudo
	
	if body.is_in_group("Inimigos"):
		if vida_escudo > 0:
			vida_escudo -= 5
			escudobar.value = vida_escudo
			if vida_escudo < 0:
				vida_escudo = 0
		else:	
			if em_coldown_invencibilidade <= 0:
				print("levou dano")
				vida -= 25
				heathlbar.value = vida
				print(vida)
				if vida <= 0:
					_die()
			tempo_invencibilidade.start()
			em_coldown_invencibilidade = tempo_maximo_de_invencibilidade

	if body.is_in_group("mini_boss"):
			if vida_escudo > 0:
				vida_escudo -= 15
				escudobar.value = vida_escudo
				if vida_escudo < 0:
					vida_escudo = 0
			else:	
				if em_coldown_invencibilidade <= 0:
					print("levou dano")
					vida -= 50
					heathlbar.value = vida
					print(vida)
					if vida <= 0:
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
