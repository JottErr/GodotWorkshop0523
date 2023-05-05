extends Area2D


var damage = 1
var speed = 500
var direction


func _ready():
	direction = (get_global_mouse_position() - position).normalized()


func _physics_process(delta):
	position += direction * speed * delta


func _on_lifetime_timeout():
	queue_free()


func _on_body_entered(body):
	body.take_damage(damage)

