extends Control


func _ready():
	$VBoxContainer/NewGameButton.connect("pressed",self,"_on_new_game_button_entered")
	$VBoxContainer/TutorialButton.connect("pressed",self,"_on_tutorial_button_entered")
	$VBoxContainer/QuitButton.connect("pressed",self,"_on_quit_button_entered")

func _on_new_game_button_entered():
	get_tree().change_scene("res://Game.tscn")

func _on_tutorial_button_entered():
	$TutorialPanel.show()

func _on_quit_button_entered():
	get_tree().quit()
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and $TutorialPanel.visible:
		$TutorialPanel.hide()