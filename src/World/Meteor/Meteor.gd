extends StaticBody2D


var health = 3
var direction
var speed


func _physics_process(delta):
	position += direction * speed * delta


# Diese Funktion wird ausgeführt sobald ein Laser mit diesem Meteor kollidiert.
# Der Laser übernimmt die Arbeit eine Kollision zu erkennen.
func take_damage(damage_value):
	health -= damage_value
	if health <= 0:
		queue_free() #Diese Funktion löscht eine Szene aus dem Szenenbaum.

