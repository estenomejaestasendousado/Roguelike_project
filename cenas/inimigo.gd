extends CharacterBody2D

const MIN_DISTANCE = 40

var movimento = Vector2()
var max_vida = 50

var debuff_ativado = false
signal died  # Declara o sinal

var tempo_de_debuff = 0
var tempo_maximo_de_debuff = 5

@onready var tempo_debuff = $Timer
@onready var health_bar = $ProgressBar

func _ready() -> void:
	add_to_group("Inimigos")
	health_bar.value = max_vida
	
func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("Player")

	# Lógica para afastar-se de outros inimigos
	var avoidance_vector = Vector2.ZERO
	var enemy_count = 0  # Contador de inimigos próximos

	for enemy in get_parent().get_children():  # Verifica todos os inimigos
		if enemy != self and position.distance_to(enemy.position) < MIN_DISTANCE:
			enemy_count += 1 
			# Calcula a direção para se afastar do inimigo próximo
			var direction = (position - enemy.position).normalized()
			avoidance_vector += direction  # Acumula a força de evasão

	# Se houver inimigos próximos, mova-se na direção de evasão
	if enemy_count > 0:
		avoidance_vector = avoidance_vector.normalized() * 50 * delta # Ajuste a força de evasão 
		position += avoidance_vector
	else:
		position += (Player.position - position).normalized() * 50 * delta
	position += (Player.position - position)/50
	look_at(Player.position)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		max_vida -= 25
		health_bar.value = max_vida
		if max_vida <= 0:
			_die_inimigo()

	if body.is_in_group("Bullet Fire"):
		_ativar_debuff()

func _on_death():
	emit_signal("died")
	queue_free()

func _die_inimigo():
	emit_signal("inimigo_morreu")
	Global._juntar_kilss()
	print(Global._juntar_kilss())
	queue_free()

func _debuff_fogo():
	if max_vida != 0:
		max_vida -= 15
		health_bar.value = max_vida
		if max_vida <= 0:
			queue_free()

func _ativar_debuff():
	debuff_ativado = true
	tempo_debuff.start()

func _desativar_debuff():
	debuff_ativado = false
	tempo_debuff.stop()	

func _on_timer_timeout() -> void:
	if debuff_ativado:
		_debuff_fogo()
		tempo_de_debuff += 1 #aqui adiciona 1 a cada chamada
		if tempo_de_debuff >= tempo_maximo_de_debuff:
			_desativar_debuff()
			tempo_de_debuff = 0
