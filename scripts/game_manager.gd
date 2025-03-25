extends Node	

var charge_states = {
	"p1": {
		"charge_level": 0,
		"can_fire": false 
	},
	"p2": {
		"charge_level": 0,
		"can_fire": false 
	},
}

var p1: CharacterBody2D
var p2: CharacterBody2D

var charge_circle:	TextureRect
var charge_circle_2:	TextureRect

signal gain_charge(who, did_shoot)

func handle_charge_states(who, did_shoot=false):
	if charge_states[who].charge_level == 100 and not did_shoot:
		print("Can fire activated")
		charge_states[who].can_fire = true
	else:
		if did_shoot:
			charge_states[who].charge_level = 0
			charge_states[who].can_fire = false
			print("SHOT FIRED")
		else:
			print("Increment")
			charge_states[who].charge_level = charge_states[who].charge_level + 25
		
	if who == "p1":
		p1.player_gain_charge.emit(who, charge_states[who].charge_level, charge_states[who].can_fire)
		charge_circle.gained_charge.emit(who, charge_states[who].charge_level)
	else:
		p2.player_gain_charge.emit(who, charge_states[who].charge_level, charge_states[who].can_fire)
		charge_circle_2.gained_charge.emit(who, charge_states[who].charge_level)
	pass
	
func _ready():
	gain_charge.connect(handle_charge_states)
