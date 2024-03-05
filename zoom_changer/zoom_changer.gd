extends Area2D

@export var zoom : float
@export var duration = 1.0

func _on_body_entered(body):
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.stop()
	tween.tween_method(body.camera.set_zoom, body.camera.get_zoom(), Vector2(zoom, zoom), duration)
	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween2.stop()
	var altered_duration = duration * (0.85 if body.camera.get_scale().x > 1/zoom else 1.25)
	tween2.tween_method(body.camera.set_scale, body.camera.get_scale(), Vector2(1/zoom, 1/zoom), altered_duration)
	tween2.play()
	tween.play()
