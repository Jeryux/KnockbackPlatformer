extends Node2D

@export var entity : PackedScene
@export var starter_to_right = true
@export var physics_direction : Vector2
@export var spawn_interval : float
@export var limit = 0

func _ready():
	$SpawnTimer.wait_time = spawn_interval

func spawn():
	if not get_child_count() > limit or limit == 0:
		var entity_instance = entity.instantiate()
		add_child(entity_instance)
		if entity_instance.is_in_group("Creature"):
			entity_instance.orient(starter_to_right)
		else:
			entity_instance.apply_central_force(physics_direction)
