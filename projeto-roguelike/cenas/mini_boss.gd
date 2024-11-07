extends CharacterBody2D

@onready var vida_progressbar = $vida
@onready var buff_debuff: Timer = $buff_debuff
@onready var animacao_mini_boss: AnimatedSprite2D = $AnimatedSprite2D
@onready var ataque: Timer = $ataque
@onready var summon_cooldwon: Timer = $summon_cooldwon
@onready var sumonar: Timer = $sumonar
@onready var area_detection: Area2D = $area_detection

var inimigo_spawn = preload("res://cenas/inimigo.tscn")
var numero_de_inimigos = 5


var vida_mini_boss = 500
var movimento = Vector2()

var debuff_ativado = false
var tempo_dando_dano = false
var tempo_sumonar = false
signal died  # Declara o sinal

var tempo_de_debuff = 0
var tempo_maximo_de_debuff = 5

var tempo_de_sumon = 0
var tempo_maximo_de_summon = 5

func _ready() -> void:
	vida_progressbar.value = vida_mini_boss
	add_to_group("Inimigos")
	add_to_group("mini_boss")

func _process(delta: float) -> void:
	if vida_mini_boss < 250 and not tempo_sumonar:
		_sumonar()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		vida_mini_boss -= 10
		vida_progressbar.value = vida_mini_boss
		if vida_mini_boss <= 0:
			_die_inimigo()

	if body.is_in_group("Bullet Fire"):
		_ativar_debuff()

	if body.is_in_group("Player"):
		tempo_dando_dano = true
		animacao_mini_boss.play("atacar")
		ataque.start(1.0)
	
func _detectar_player():
	if not tempo_dando_dano and not tempo_sumonar:
		animacao_mini_boss.play("andar")
		var Player = get_parent().get_node_or_null("Player")
		if Player != null:
			look_at(Player.position)
			position += (Player.position - position)/50
			move_and_slide()
	
func _on_death():
	emit_signal("died")
	queue_free()

func _die_inimigo():
	emit_signal("inimigo_morreu")
	queue_free()


func _debuff_fogo():
	if vida_mini_boss != 0:
		vida_mini_boss -= 5
		buff_debuff.value = vida_mini_boss
		if vida_mini_boss <= 0:
			queue_free()

func _ativar_debuff():
	debuff_ativado = true
	buff_debuff.start()

func _desativar_debuff():
	debuff_ativado = false
	buff_debuff.stop()	

func _sumonar():
	tempo_sumonar = true
	animacao_mini_boss.play("sumonar")
	sumonar.start(2.0)

func _desativar_summon():
	buff_debuff.stop()	

func _on_ataque_timeout() -> void:
	tempo_dando_dano = false 
	animacao_mini_boss.play("andar")

func _on_sumonar_timeout() -> void:
	for i in range(numero_de_inimigos):
			var inimigo = inimigo_spawn.instantiate()
			inimigo.position = position + Vector2(randf_range(-75,75), randf_range(-75, 75))
			get_tree().current_scene.add_child(inimigo)
	summon_cooldwon.start()
	tempo_sumonar = false 
	animacao_mini_boss.play("andar")

func randf_range(min, max):
	return min + randf() * (max - min)

func _on_buff_debuff_timeout() -> void:
	if debuff_ativado:
		_debuff_fogo()
		tempo_de_debuff += 1 #aqui adiciona 1 a cada chamada
		if tempo_de_debuff >= tempo_maximo_de_debuff:
			_desativar_debuff()
			tempo_de_debuff = 0

func _on_summon_cooldwon_timeout() -> void:
	if tempo_de_sumon:
		_sumonar()
		tempo_de_sumon += 1
		if tempo_de_sumon >= tempo_maximo_de_summon:
			_desativar_summon()
			tempo_de_sumon = 0


func _on_area_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_detectar_player()
