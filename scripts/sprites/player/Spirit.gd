extends Node2D
# This is an event handler for Spirit

onready var healthBar = get_node("Spirit/Camera/Health-Bar")

export (int) var Health = 100
export (int) var Power = 2
export (int) var Speed = 20
export (int) var Damage = 4
export (String) var Name = "Spirit"

# Jump handler
export (bool) var Can_Jump = true

# Flower handler
export (bool) var Is_Powered = false

# Full Power Handler
export (bool) var Is_Shielding = false

const PLAY_SCENE_PATH = "res://scenes/elder-grove/Devorrins-Lair.tscn"

func _ready():
	set("NAME", "SPIRIT")
	healthBar.set_name("Spirit")
	healthBar.set_health(Health)
	healthBar.set_power(Power)

func _process(delta):
	if Power == 100:
		Is_Shielding = true
	if Is_Shielding:
		update_ep(Power - 1)
		if Power < 5:
			Is_Shielding = false
	if Health < 2:
		get_tree().quit()
		
	healthBar.update()

func update_hp(hp):
	Health = hp
	healthBar.set_health(Health)

func update_ep(ep):
	Power = ep
	healthBar.set_power(Power)

# Jump Bodies
func block_jump():
	Can_Jump = false

func allow_jump():
	Can_Jump = true

func get_jump():
	return Can_Jump

func _on_ground_collision(body):
	allow_jump()

func powerup():
	Is_Powered = true

func powerdown():
	Is_Powered = false

# Flower Physics
func _on_flower_collect(body):
	if body.get_name() == "Spirit":
		update_ep(100)
		powerup()

# Area Physics
func _on_area_entered(body):
	if body.get_class() == "RigidBody2D":
		if !body.has_meta("NAME"):
			update_hp(Health - 5)
	elif body.get_class() == "KinematicBody2D":
		if body.get_name() != "Spirit":
			update_hp(Health - 10)


func _on_Next_body_entered(body):
	if body.get_name() == "Spirit":
		get_tree().change_scene(PLAY_SCENE_PATH)
