extends CharacterBody2D

var is_panning = false

@onready var camera = $Camera2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_panning:
		position.x += -event.relative.x
		position.y += -event.relative.y

func _process(delta: float) -> void:
	if Input.is_action_pressed("pan"):
		is_panning = true
	else:
		is_panning = false
	if Input.is_action_pressed("scrolldown"):
		camera.zoom += Vector2(0.05,0.05) * delta
	elif Input.is_action_pressed("scrollup"):
		camera.zoom -= Vector2(0.05,0.05) * delta
	
	camera.zoom = clamp(camera.zoom, Vector2(0.25,0.25), Vector2(3,3))