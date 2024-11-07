extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_body_entered"))
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Verifica se o jogador colidiu
		var next_scene = preload("res://cenas/fase_dois.tscn")
		get_tree().change_scene_to_packed(next_scene)  # Corrigido 'next_scen	e' para 'next_scene'
		print("Fase dois carregada")
