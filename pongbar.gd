extends Area2D

const MOVE_SPEED = 100
@export var score: int = 0
var ball = false
var _ball_dir
var _up
var _down

@onready var _screen_size_y = get_viewport_rect().size.y


func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	if name.to_int() == 1:
		position = Vector2(45, 298)
	else:
		position = Vector2(746.995, 298)


func _ready() -> void:
	if not is_multiplayer_authority(): 
		return


func _process(delta: float) -> void:
	$Label.text = str(score)
	# Set ball direction based on paddle position
	if position.x == 45:  # Left paddle
		_ball_dir = 1
	else:  # Right paddle
		_ball_dir = -1
		
	if not is_multiplayer_authority(): 
		return
	
	# Simple up/down movement
	if Input.is_action_pressed("ui_up"):
		position.y -= 5
	if Input.is_action_pressed("ui_down"):
		position.y += 5
	
	# Keep paddle within screen bounds
	position.y = clamp(position.y, 16, _screen_size_y - 16)


func _on_area_entered(area):
	if area.ball:  # Keep your check
		var hit_pos_rel = (area.position.y - position.y) / 50.0  # Adjust divisor for sensitivity
		var new_dir = Vector2(_ball_dir, clamp(hit_pos_rel, -0.9, 0.9)).normalized()
		area.direction = new_dir
