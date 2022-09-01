extends Area2D

export(String, FILE, "*.tscn") var target_stage


func _on_ChangeStage_body_entered(body: Node):
	if body.is_in_group("player"):
		var err := get_tree().change_scene(target_stage)
		if err != OK:
			printerr("Cannot load scene")
