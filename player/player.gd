extends CharacterBody2D

#region properties
@export var speed = 150
@export var base_acceleration = 30
@export var jump_power = -300
@export var bullet_capacity := 2
@export var gravity = 800
@export var zoom := 4.0
@onready var sprite = $Sprite
@onready var gun = $Gun
@onready var buffer_jump_timer = $BufferJumpTimer
@onready var coyote_time_timer = $CoyoteTimeTimer
@onready var camera : Camera2D = $Camera
@onready var reload_effect = $Gun/ReloadEffect

var jumping = false
var coyote = false
var last_floor : bool
var buffered_jump = false
var acceleration
var ammo
var reloading = false
var can_shoot = true
var dead = false

var bullet_scene = preload("res://player/bullet/bullet.tscn")
@export var respawn_point : Node
#endregion

func _ready():
	camera.zoom = Vector2(zoom, zoom)
	camera.scale = Vector2(1.0/zoom, 1.0/zoom)
	acceleration = base_acceleration
	ammo = bullet_capacity
	if respawn_point != null:
		respawn_point.active(true)
		respawn_point.camera_zoom = camera.zoom

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if dead:
		if Input.is_action_just_pressed("reload"):
			respawn(respawn_point.give_respawn_pos())
		return
	if Input.is_action_just_pressed("jump"):
		buffered_jump = true
		buffer_jump_timer.start()
	if event is InputEventMouseMotion:
		gun.look_at(get_global_mouse_position())
		var result = fmod(gun.get_rotation() + PI / 2, 2 * PI)
		gun.flip_v = result > PI or (result < 0 and result > -PI)
	if Input.is_action_just_pressed("shoot") and not reloading and can_shoot:
		shoot()
	if Input.is_action_just_pressed("reload") and not reloading and ammo != bullet_capacity:
		reload()

func _physics_process(delta):
	var calculated_speed = (int)((pow(pow(velocity.x, 2) + pow(velocity.y, 2), 0.5)) / 20.0)
	$Camera/Speed.text = (str)(calculated_speed) + "km/h"
	if calculated_speed > 45:
		$Camera/Speed.label_settings.font_color = Color(0.25, 0, 0.9, 1)
	else:
		$Camera/Speed.label_settings.font_color = Color(1, 1, 1, 1)
	if dead:
		return
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		jump()
	if not is_on_floor() and last_floor and not jumping:
		coyote = true
		coyote_time_timer.start()
	if buffered_jump and is_on_floor():
		buffered_jump = false
		jump()
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y >= 0 and is_on_floor():
		jumping = false
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction, base_acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	last_floor = is_on_floor()
	if is_on_floor():
		acceleration = base_acceleration
	move_and_slide()

func reload_finish():
	ammo = bullet_capacity
	reloading = false
	$ReloadAnimation.visible = false

func die():
	dead = true
	sprite.visible = false
	gun.visible = false
	$ReloadAnimation.visible = false
	$DeathEffect.restart()
	$DeathEffect.emitting = true

func respawn(location : Vector2):
	velocity = Vector2.ZERO
	ammo = bullet_capacity
	global_position = location
	dead = false
	sprite.visible = true
	gun.visible = true
	$DeathEffect.emitting = false
	camera.zoom = respawn_point.camera_zoom
	camera.scale = Vector2(1.0/respawn_point.camera_zoom.x, 1.0/respawn_point.camera_zoom.x)

func shoot():
	var bullet_instance : Bullet = bullet_scene.instantiate()
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.transform = gun.get_global_transform()
	bullet_instance.play()
	ammo -= 1
	can_shoot = false
	$CanShootTimer.start()
	if ammo == 0:
		reload()

func reload():
	reloading = true
	$ReloadAnimation.visible = true
	$AnimationPlayer.play("reload")
	reload_effect.amount = bullet_capacity - ammo
	reload_effect.emitting = true

func jump():
	velocity.y = jump_power
	jumping = true

func _on_can_shoot_timer_timeout():
	can_shoot = true

func _on_buffer_jump_timer_timeout():
	buffered_jump = false

func _on_coyote_time_timer_timeout():
	coyote = false

func interact(_body):
	die()


func area_interact(area):
	if area.is_in_group("RespawnPoint") and area != respawn_point:
		if respawn_point != null:
			respawn_point.active(false)
		respawn_point = area
		respawn_point.active(true)
		respawn_point.camera_zoom = camera.zoom
