extends Area2D


func _on_PowerUp_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	body.power_up(5)
	call_deferred("queue_free")
