extends Area2D

const DEFAULT_SPEED = 100
var ball = true  # Keep your variable
@export var _speed = DEFAULT_SPEED
@export var direction = Vector2.from_angle(35)  # Initial angle

@onready var _initial_pos = position

func _enter_tree() -> void:
	position = Vector2(393, 246)
	scale = Vector2(3.0, 3.0)

func _process(delta):
	# Movement with speed increase over time
	position += _speed * delta * direction
	_speed += delta * 2  # Gradual speed increase

	# Screen boundary check (top and bottom)
	if position.y <= 0 or position.y >= get_viewport_rect().size.y:
		direction.y *= -1  # Reverse Y direction on wall hit

func reset():
	direction = Vector2.LEFT if randi() % 2 == 0 else Vector2.RIGHT  # Randomize starting side
	position = _initial_pos
	_speed = DEFAULT_SPEED
