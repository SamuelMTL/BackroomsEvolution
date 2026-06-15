extends CharacterBody2D

const SPEED := 120.0

func _ready() -> void:
	_pick_random_direction()

func _physics_process(_delta: float) -> void:
	var collision := move_and_collide(velocity * _delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

func _pick_random_direction() -> void:
	var angle := randf() * TAU
	velocity = Vector2(cos(angle), sin(angle)) * SPEED
