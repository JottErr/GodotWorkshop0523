extends StaticBody2D


var health = 3
var direction
var speed


func _physics_process(delta):
	position += direction * speed * delta


func take_damage(damage_value):
	health -= damage_value
	if health <= 0:
		queue_free()

