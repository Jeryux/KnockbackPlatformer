extends Node2D

@export var entity : PackedScene
@export var starter_to_right = true
@export var physics_direction : Vector2
@export var spawn_interval : float
@export var limit = 0
@export var horizontal_shoot = false
@onready var bb = $BackBufferCopy

func _ready():
	$SpawnTimer.wait_time = spawn_interval

func spawn():
	if not bb.get_child_count() > limit or limit == 0:
		var entity_instance = entity.instantiate()
		bb.add_child(entity_instance)
		bb.move_child(entity_instance, 0)
		if entity_instance.is_in_group("Creature"):
			entity_instance.orient(starter_to_right)
		else:
			if not horizontal_shoot:
				entity_instance.add_gravity()
			else:
				var timer := Timer.new()
				add_child(timer)
				timer.set_wait_time(0.05)
				timer.one_shot = true
				timer.timeout.connect(add_gravity.bind(entity_instance, timer))
				timer.start()
			entity_instance.apply_central_force(physics_direction)

func add_gravity(object, timer):
	object.add_gravity()
	timer.queue_free()
