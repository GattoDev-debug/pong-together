extends Node2D
var Player = preload("res://pongbar.tscn")
var Ball = preload("res://ball.tscn")
var opponent_id : int
var gr : bool
@export var gpaused : bool
var enet_peer = ENetMultiplayerPeer.new()
func _on_button_pressed() -> void:
	$menu.hide()
	enet_peer.create_server(int($menu/TextEdit2.text))
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(create_player)
	multiplayer.peer_disconnected.connect(remove_player)
	create_player(multiplayer.get_unique_id())
	create_ball(multiplayer.get_unique_id())
	$waiting.show()
	gpaused = true
func _on_button_2_pressed() -> void:
	$menu.hide()
	enet_peer.create_client($menu/TextEdit.text, int($menu/TextEdit2.text))
	multiplayer.multiplayer_peer = enet_peer
	create_player(multiplayer.get_unique_id())
	create_ball(multiplayer.get_unique_id())
	$waiting.show()
	gpaused = true
func create_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	if not peer_id == 1:
		gpaused = false
		$waiting.hide()
		opponent_id = peer_id
func create_ball(peer_id):
	var ball = Ball.instantiate()
	ball.name = str(peer_id)
	add_child(ball)
	print("done")
	gr = true
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	player.queue_free()
	$waiting.show()
	gpaused = true
# Helper function to show popups (error or success)
func _show_popup(title: String, message: String, is_success: bool) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = title
	dialog.dialog_text = message
	
	# Style differently for success/error
	if is_success:
		dialog.add_theme_color_override("title_color", Color.GREEN)
	else:
		dialog.add_theme_color_override("title_color", Color.RED)
	
	# Add to scene tree and show
	get_tree().root.add_child(dialog)
	dialog.popup_centered()
	
	# Auto-cleanup when closed
	dialog.confirmed.connect(func(): dialog.queue_free())
	dialog.canceled.connect(func(): dialog.queue_free())
func _process(delta: float) -> void:
	get_tree().paused = gpaused
	$menu/TextEdit3.text = $menu/TextEdit2.text

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area.ball:
		$AudioStreamPlayer.play()
		get_node_or_null(str(1)).score += 1
		area.position = Vector2(393, 246)


func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.ball:
		$AudioStreamPlayer.play()
		get_node_or_null(str(opponent_id)).score += 1
		area.position = Vector2(393, 246)
		
