extends Area2D


var damage = 1
var speed = 500
var direction


# Der Laser soll nur eine Lebensdauer von einer Sekunde haben. Da dafür erstellte
# Lifetime Timer startet automatisch sobald diese Szene erstellt wird.
# Im Player Skript ist zu sehen, wie ein Skript auf Funktionen und Eigenschaften
# eines child nodes zugreifen kann (GunPivot wird rotiert, LaserCooldown gestartet). 
# Im Gegensatz dazu möchte an dieser Stelle das child node (Lifetime) eine Funktion 
# auf einem höher angeordnenten (parent node) ausführen. Wenn der Timer abgelaufen ist
# soll der Laser wieder aus dem Spiel verschwinden.
# Dafür gibt es Signale. Signale sind hauptsächlich eine Form der Organisation.
# Das timeout Signal des Timers wird in diesem Fall mit der _on_lifetime_timeout()
# Funktion verbunden. Kann bei angewähltem Timer im Inspektor über den Node-Reiter 
# nachgesehen werden. So benötigt der Timer kein eigenes Skript um eine spezifische
# Aktion in dieser Szene auszulösen. 


func _ready():
	# Um einen Vektor zu erhalten der von Vektor_A zu Vektor_B zeigt,
	# Rechnet man Vektor_B - Vektor_A. Um den Vektor auf die für Richtungsvektoren
	# übliche Länge von 1 zu bringen, wird das Resultat normalisiert.
	direction = (get_global_mouse_position() - position).normalized()


func _physics_process(delta):
	position += direction * speed * delta


#Diese Funktion wird ausgeführt sobald der Lifetime Timer abegelaufen ist.
func _on_lifetime_timeout():
	queue_free() #Diese Funktion löscht eine Szene aus dem Szenenbaum.


# Diese Funktion wird ausgeführt, sobald das Area2D Node (hier umbenannt zu 'Laser') eine 
# Kollision mit einem Meteoriten signalisiert. Kollisionen können im Inspektor auf dem 
# Laser Node eingestellt werden (CollisionObject2D/Collision).
# Das Layer gibt an was für eine Objekt dieses Node ist.
# 1 = Player, 2 = Laser, 3 = Meteor. 
# In diesem Fall ist Layer 2 angewählt.
# Die Mask gibt mit welchen Objekten diese Szene kollidieren soll.
# In diesem Fall ist nur Layer 3 ausgewählt. Der Laser soll nie mit dem Player oder anderen Lasern 
# kollidieren (also nie mit Layer 1 oder 2).
func _on_body_entered(body):
	# Wenn ein Laser mit einem body kollidiert, wollen wir diesem body Schaden zufügen.
	# Dafür wird die take_damage Funktion des bodys aufgerufen. Man könnte auch 
	# Eigenschaften des bodies an dieser Stelle verändern. Oft ist es jedoch sinnvoll
	# Code so zu organisieren, dass Objekte ihre eigenen Eigenschaten manipulieren.
	body.take_damage(damage)

