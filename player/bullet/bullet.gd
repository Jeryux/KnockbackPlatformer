extends RayCast2D
class_name Bullet

@onready var line = $Line2D
@onready var hit_particles = $HitParticles
@onready var beam_particles = $BeamParticles
@onready var knockback = $Knockback
@onready var knockback_shape = $Knockback/KnockbackShape
@export var duration := 0.2
@export var width := 1.0
@export var flash_color : Color = Color(1, 1, 1, 1)
@export var knockback_strenght = 600
@export var knockback_radius : int
@export var max_knockback = 1200

func _ready():
	knockback_shape.shape.radius = knockback_radius

func play():
	var cast_point := target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		hit_particles.global_rotation = get_collision_normal().angle()
		hit_particles.position = cast_point
		knockback.position = cast_point
		knockback_shape.disabled = false
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	line.points[1] = cast_point
	
	line.default_color = Color(1, 0.655, 0.975, 1)
	$CastParticles.emitting = true
	if is_colliding():
		hit_particles.emitting = true
	beam_particles.emitting = true
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.connect("finished", disappear)
	tween.stop()
	tween.tween_property(line, "width", width, duration)
	tween.play()
	
	$DisableTimer.start()
	
	var tween3 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween3.stop()
	tween3.tween_method(RenderingServer.set_default_clear_color, flash_color, Color(0, 0, 0, 1), duration)
	tween3.play()

func disappear():
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.stop()
	tween.tween_property(line, "width", 0.0, duration)
	tween.play()
	tween2.stop()
	tween2.tween_property(line, "default_color", Color(1, 0.655, 0.975, 0), duration)
	tween2.play()


func _on_removal_timer_timeout():
	queue_free()

func disable_knockback():
	knockback_shape.disabled = true

func _on_knockback_body_entered(body):
	var knockback_angle = fmod(rotation + PI, 360)
	var distance = get_collision_point().distance_to(body.position)
	var knockback_velocity := Vector2.ZERO
	knockback_velocity.y = sin(knockback_angle) * knockback_strenght
	knockback_velocity.x = cos(knockback_angle) * knockback_strenght
	if distance > 35:
		knockback_velocity /= 1.5
	body.velocity += knockback_velocity
	body.movement_manager.acceleration /= 20
	knockback_shape.set_deferred("disabled", true)
