extends CharacterBody2D

var movimento = Vector2()
var max_vida = 150

var debuff_ativado = false

var tempo_de_debuff = 0
var tempo_maximo_de_debuff = 5

@onready var tempo_debuff = $Timer

func _ready() -> void:
	add_to_group("Inimigos")
	print(max_vida, "Vida total")
	
func _physics_process(delta: float) -> void:
	var Player = get_parent().get_node("Player")
	position += (Player.position - position)/50
	look_at(Player.position)
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		max_vida -= 20
		print(max_vida, " DANO BASE")
		if max_vida <= 0:
			queue_free()

	if body.is_in_group("Bullet Fire"):
		_ativar_debuff()

func _debuff_fogo():
	if max_vida != 0:
		max_vida -= 5
		print(max_vida, " DANO COM DEBUFF")
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
