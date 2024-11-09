extends CharacterBody2D

@onready var barra_de_vida: ProgressBar = $ProgressBar
@onready var debuff_fogo: Timer = $debuff_fogo
@onready var dando_dano: Timer = $dando_dano
@onready var animacao_boss: AnimatedSprite2D = $AnimatedSprite2D
@onready var Player = get_parent().get_node("Player")
var vida_boss = 1200 #padrão 12000
var is_dead = false
var debuff_ativado = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var tempo_de_debuff = 0
var tempo_maximo_de_debuff = 5

var tempo_dando_dano = false

func _ready() -> void:
	barra_de_vida.value = vida_boss
	add_to_group("Boss")
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if not tempo_dando_dano:
		if not animacao_boss.is_playing() or animacao_boss.animation != "walk":
			animacao_boss.play("walk")
		var direction = (Player.position - position).normalized()
		velocity = direction * 320
		if direction.x > 0:
			animacao_boss.flip_h = true
		else:
			animacao_boss.flip_h = false
	move_and_slide()

#Area Debuff
func _debuff_fogo():
	if vida_boss != 0:
		vida_boss -= 25
		barra_de_vida.value = vida_boss
		if vida_boss <= 0:
			queue_free()

func _ativar_debuff():
	debuff_ativado = true
	debuff_fogo.start()

func _desativar_debuff():
	debuff_ativado = false
	debuff_fogo.stop()	

func _on_debuff_fogo_timeout() -> void:
	if debuff_ativado:
		_debuff_fogo()
		tempo_de_debuff += 1 #aqui adiciona 1 a cada chamada
		if tempo_de_debuff >= tempo_maximo_de_debuff:
			_desativar_debuff()
			tempo_de_debuff = 0
#area debuff

func _die_inimigo():
	animacao_boss.stop()
	animacao_boss.play("dead")
	is_dead = true  
	velocity = Vector2.ZERO
	emit_signal("inimigo_morreu")
	await get_tree().create_timer(3).timeout
	queue_free()



func _on_dando_dano_timeout() -> void:
	tempo_dando_dano = false 
	if not animacao_boss.is_playing() or animacao_boss.animation != "walk":
		animacao_boss.play("walk")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		vida_boss -= 50
		barra_de_vida.value = vida_boss
		if vida_boss <= 0:
			_die_inimigo()
	
	if body.is_in_group("Player"):
		tempo_dando_dano = true
		animacao_boss.play("atack")
		dando_dano.start(1.0)
		var direction = (Player.position - position).normalized()
		velocity = direction * 0
	
	if body.is_in_group("Bullet Fire"):
		_ativar_debuff()
