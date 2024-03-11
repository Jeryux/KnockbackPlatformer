extends RigidBody2D

@onready var impact = $Impact
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func remove(body):
	if body.is_in_group("Player"):
		body.die()
	sprite.visible = false
	impact.emitting = true
	collision.set_deferred("disabled", true)
	$DeleteTimer.start()


func delete():
	queue_free()
