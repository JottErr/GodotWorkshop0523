extends CharacterBody2D


@export var max_speed = 300

var laser_scene = preload("res://src/Player/Laser/Laser.tscn")

@onready var gun_pivot = $GunPivot
@onready var laser_cooldown = $LaserCooldown


func _physics_process(delta): #delta = 1 / 60 = 0.016666
	move_character()
	limit_position_to_screen()
	gun_pivot.look_at(get_global_mouse_position())
	fire_laser()


func move_character():
	var move_direction = Vector2.ZERO
	
	#Wenn wir eine Taste drücken, übersetzen wir diese in einen Richtungsvektor
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
		
	#Der Richtungungsvektor wird dann auf eine Länge von 1 normalisiert
	#und um die maximale Geschwindigkeit verlängert.
	velocity = move_direction.normalized() * max_speed
	move_and_slide()


func limit_position_to_screen():
	position.x = clamp(position.x, 0, 1280)
	position.y = clamp(position.y, 0, 720)


func fire_laser():
	if Input.is_action_pressed("fire_laser") and laser_cooldown.is_stopped():
		laser_cooldown.start()
		var new_laser = laser_scene.instantiate()
		new_laser.position = position
		new_laser.look_at(get_global_mouse_position())
		add_child(new_laser)


