extends Control


func _ready():
	$VBoxContainer/NewGameButton.connect("pressed",self,"_on_new_game_button_entered")
	$VBoxContainer/QuitButton.connect("pressed",self,"_on_quit_button_entered")
	$VBoxContainer/NewGameButton.connect("mouse_entered",self,"_on_newgame_button_hovered")
	$VBoxContainer/QuitButton.connect("mouse_entered",self,"_on_quit_button_hovered")
	$VBoxContainer/NewGameButton.connect("mouse_exited",self,"_on_button_unhovered")
	$VBoxContainer/QuitButton.connect("mouse_exited",self,"_on_button_unhovered")

func _on_new_game_button_entered():
	get_tree().change_scene("res://Game.tscn")

func _on_tutorial_button_entered():
	$TutorialPanel.show()

func _on_quit_button_entered():
	get_tree().quit()
	
func _on_newgame_button_hovered():
	$Hand.show()
	$Hand.rect_position = Vector2(170,290)
	
func _on_quit_button_hovered():
	$Hand.show()
	$Hand.rect_position = Vector2(170,420)
	
func _on_button_unhovered():
	$Hand.hide()
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and $TutorialPanel.visible:
		$TutorialPanel.hide()