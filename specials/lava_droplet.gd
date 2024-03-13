extends RigidBody2D

@onready var impact = $Impact
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var detector = $Area2D

func remove(body):
	collision.queue_free()
	detector.queue_free()
	if body.is_in_group("Player"):
		body.die()
	sprite.visible = false
	impact.emitting = true
	$DeleteTimer.start()


func delete():
	queue_free()
