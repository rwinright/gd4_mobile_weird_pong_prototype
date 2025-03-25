extends TextureRect

@export var player2 := false

var atlas_region:Rect2 = texture.region
var charge_percent := 0

#only on the X axis (this is to control which section of the texture to render)
var region_coords = {
	0: 832,
	25: 896,
	50: 960,
	75: 1024,
	100: 1280
}

signal gained_charge(who, amount)

func _ready():
	gained_charge.connect(gain_charge)
	if not player2:
		GameManager.charge_circle = self
	else:
		GameManager.charge_circle_2 = self

func gain_charge(who, amount):
	print(who + "gained_charge signal fired")
	charge_percent = amount
	if who == "p2" and player2:
		texture.region.position.x = region_coords[charge_percent]
	else:
		texture.region.position.x = region_coords[charge_percent]
