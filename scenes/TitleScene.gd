extends Control
# control title menu

export(NodePath) var start_button_path
export(NodePath) var exit_button_path

onready var start_button := get_node(start_button_path) as Button
onready var exit_button := get_node(exit_button_path) as Button


func _ready():
	start_button.grab_focus()
	

func _process(_delta: float) -> void:
	if start_button.is_hovered():
		start_button.grab_focus()
	if exit_button.is_hovered():
		exit_button.grab_focus()


func _on_ButtonStart_pressed():
	var err = get_tree().change_scene("res://scenes/StageOne.tscn")
	if err != OK:
		print("Cannot load scene")


func _on_ButtonExit_pressed():
	get_tree().quit()
