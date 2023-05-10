extends CharacterBody2D


# Exportierte Variablen tauchen im Inspektor auf und können darüber verändert werden.
# Das funktioniert sogar im laufenden Spiel. Ansonsten verhalten sie sich genau wie 
# alle anderen Variablen.
@export var max_speed = 300

# Lädt die Datei der Laser Szene. Vorbereitung um diese später auf Knopfdruck 
# instanzieren zu können.
var laser_scene = preload("res://src/Player/Laser/Laser.tscn")

# Um aus diesem Skript auch die Eigenschaften und Funktionen von Kindern (child nodes)
# zugreifen zu können, werden diese in einer Variable gespeichert. 
# Es wird eine 'Referenz' gespeichert, dies kann man sich vorstellen wie eine Adresse
# unter der das child node zu finden ist. Dafür gibts es zwei Schreibweisen, die exakt 
# das selbe bewirken. Die $ Schreibweise ist lediglich die Kurzform.
@onready var gun_pivot = get_node("GunPivot")
@onready var laser_cooldown = $LaserCooldown
# Warum wird @onready verwendet?
# Wenn diese Szene ausgeführt wird, wird zuerst das Player Node instanziert.
# Dabei werden alle Variablen erstellt (wie max_speed oder laser_scene).
# Erst danach werden die child nodes der Reihe nach instanziert (CollisionShape, Sprite, ...)
# Der Player kann also keine Referenz zu einem child node in einer Variable speichern,
# da zum Zeitpunkt an dem Variablen erstellt werden, noch keine child nodes instanziert sind.
# Praktischerweise wird die _ready() Funktion in genau umgekehrter Reihenfolge aufgerufen.
# Erst wenn alle child nodes ihre _ready() Funktion aufgerufen haben, wird diese Funktion
# beim root node (in diesem Fall Player) aufgerufen. 
# @onready erlaubt es das es Erstellen von Variablen auf diesen Zeitpunkt zu verzögern.


func _physics_process(delta):
	move_character()
	limit_position_to_screen()
	gun_pivot.look_at(get_global_mouse_position())
	fire_laser()


func move_character():
	# Es gibt voreingestellte Richtungsvektoren wie .ZERO oder .RIGHT
	# Vector2.RIGHT ist das gleiche wie Vector2(1.0, 0.0)
	# Richtungsvektoren haben üblicherweise eine Länge von 1
	
	# Eine Variable für die Bewegungsrichtung
	var move_direction = Vector2.ZERO
	
	# Wenn wir eine Taste drücken, übersetzen wir diese Aktion in einen Richtungsvektor
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
	
	# Durch das simple Addieren von Richtungsvektoren, entstehen bei diagonaler
	# Bewegunng (z.b. hoch und rechts) Vektoren mit einer Länge von über 1 (ungefähr 1.41)
	# Um eine gleiche Geschwindigkeit in alle Bewegungsrichtungen zu erhalten,
	# wird der Bewegungsrichtungsvektor normalisiert. Danach zeigt er in die selbe Richtung
	# hat aber garantiert eine Länge von 1.
	# Anschließend wird der Vektor um die maximale Geschwindigkeit verlängert.
	velocity = move_direction.normalized() * max_speed
	move_and_slide()


func limit_position_to_screen():
	# Die clamp Funktion stellt sicher, dass der Spieler das Fenster nicht verlassen kann.
	position.x = clamp(position.x, 0, 1280)
	position.y = clamp(position.y, 0, 720)


func fire_laser():
	# LaserCooldown ist ein Timer Node, bei dem eine Wartezeit von 0.2 s über den Inspektor
	# eingestellt wurde. Der Laser kann nur abgefeuert werden wenn der Timer abgelaufen ist.
	# Das kann mit den .is_stopped() Funktion abgefragt werden. Zu Spielbeginn ist der Timer gestoppt.
	if Input.is_action_pressed("fire_laser") and laser_cooldown.is_stopped():
		laser_cooldown.start() #Startet den 0.2 Sekunden Timer, der erneutes Abfeuern verhindert.
		
		# Eine neue laser Szene wird instanziert und als Kind hinzugefügt.
		var new_laser = laser_scene.instantiate()
		new_laser.position = position
		new_laser.look_at(get_global_mouse_position())
		add_child(new_laser)
		# An dieser Stelle wird der Laser dem Szenenbaum (unter LaserCooldown) hinzugefügt.
		# Danach wird noch die _ready() Funktion des Laser.gd Skripts ausgeführt.


