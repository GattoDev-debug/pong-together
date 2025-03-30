extends Area2D

var ball = false
@export var _bounce_direction = 1


func _on_area_entered(area):
	if area.ball:
		area.direction = (area.direction + Vector2(0, _bounce_direction)).normalized()
