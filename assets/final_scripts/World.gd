extends Node2D


var meteor_scene = preload("res://src/World/Meteor/Meteor.tscn")
@onready var meteor_spawn_location = $MeteorSpawnPath/MeteorSpawnLocation


func _on_timer_timeout():
	#Bewege das PathFollow Node an eine zufällige Position des Pfads um das Fenster 
	meteor_spawn_location.progress_ratio = randf()
	#Instanziere einen neuen Meteor
	var new_meteor = meteor_scene.instantiate()
	#Setze die Position des Meteors gleich der Position des PathFollow Nodes
	new_meteor.position = meteor_spawn_location.position
	#Drehe den Meteor um 90 Grad damit er einmal quer oder längs über das Fenster fliegt
	var angle = meteor_spawn_location.rotation + deg_to_rad(90)
	#Füge eine zufällige Rotation von +/- 45 Grad hinzu
	angle += randf_range(deg_to_rad(-45), deg_to_rad(45))
	#Setze den selbst erstellten Richtungsvektor im Meteor Skript
	new_meteor.direction = Vector2.from_angle(angle)
	#Setze die selbst erstellte Geschwindigkeits Variable im Meteor Skript 
	#auf einen zufälligen Wert
	new_meteor.speed = randf_range(150.0, 250.0)
	#Füge den Meteor als child node hinzu
	call_deferred("add_child", new_meteor)
	#Warum nicht einfach mit add_child(new_meteor)?
	#Diese Funktion wird als Reaktion auf ein Signal ausgeführt (Timeout des Timers)
	#Hinter den Kulissen ist Godot so organisiert, dass Signale zu einem bestimmten
	#Zeitpunkt abgearbeitet werden. Es passt nicht in diese Organisation zu diesem
	#Zeitpunkt dem Szenenbaum neue Nodes hinzuzufügen. 
	#Um nicht groß in diese Organisation eingreifen zu müssen, kann mit call_deferred
	#ein Vermerk für die Engine erstellt werden. Godot wird die Funktion "add_child"
	#zu einem passenden Zeitpunkt ausführen und dabei new_meteor als Argument benutzen.
	#add_child(new_meteor) 
