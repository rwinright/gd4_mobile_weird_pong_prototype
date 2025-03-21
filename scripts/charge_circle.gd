extends TextureRect

@export var player2 := false

var atlas_region:Rect2 = texture.region
var charge_percent := 0
var times_run = 0

#only on the X axis
var region_coords = {
	0: 832,
	25: 896,
	50: 960,
	75: 1024,
	100: 1280
}
#define custom signal
signal gained_charge(who)

# hook a function to it when the thing's instantiated
func _ready():
	gained_charge.connect(gain_charge)

# do shit
func gain_charge(who):
	var gm_charge_state = GameManager.charge_states[who].charge_level
	charge_percent = gm_charge_state
	
	if (gm_charge_state < 100):
		gm_charge_state += 25
	else:
		gm_charge_state = 0
		
	GameManager.charge_states[who].charge_level = gm_charge_state
	
	if who == "p2" and player2:
		texture.region.position.x = region_coords[GameManager.charge_states[who].charge_level]
	else: 
		texture.region.position.x = region_coords[GameManager.charge_states[who].charge_level]
