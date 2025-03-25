extends CharacterBody2D

@export var speed = 8000
@export var player2 = false
@export var touch_controls = false

var shot_enabled = false
var shot_charge := 0.0

@onready var button:Button = $"../UI/Button"
@onready var button2:Button = $"../UI/Button2"

signal player_gain_charge(who: String, amount: int, can_fire: bool)

var touch_events = {
	"p1": {
		"position": Vector2(),
		"pressed": false
	},
	"p2": {
		"position": Vector2(),
		"pressed": false
	},
}

func _ready():
	if not player2:
		GameManager.p1 = self
	else:
		GameManager.p2 = self
	
	var p1handle_fire = func(): return handle_fire(false)
	var p2handle_fire = func(): return handle_fire(true)
	button.pressed.connect(p1handle_fire)
	button2.pressed.connect(p2handle_fire)
	player_gain_charge.connect(gain_charge)

func _physics_process(delta):
	velocity.y = handle_input_dir() * speed * delta
	velocity.x = 0
	move_and_slide()

func handle_input_dir():
	var move_dir := 0
	
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_rect_size = get_viewport_rect().size
	
	var screen_coords = {
		"top_left": Rect2(0, 0, viewport_rect_size.x/2, viewport_rect_size.y/2),
		"top_right": Rect2(viewport_rect_size.x/2, 0, viewport_rect_size.x/2, viewport_rect_size.y/2),
		"bottom_left": Rect2(0, viewport_rect_size.y/2, viewport_rect_size.x/2, viewport_rect_size.y/2),
		"bottom_right": Rect2(viewport_rect_size.x/2, viewport_rect_size.y/2, viewport_rect_size.x/2, viewport_rect_size.y/2),
	}
	
	for coord in screen_coords:
		var coord_val: Rect2 = screen_coords[coord]
		for touch_position in touch_events:
			var touch_val = touch_events[touch_position]
			if coord_val.has_point(touch_val.position) and touch_val.pressed:
				match coord:
					"top_left":
						if not player2:
							move_dir = -1
						pass
					"bottom_left":
						if not player2:
							move_dir = 1
						pass
					"top_right":
						if player2:
							move_dir = -1
						pass
					"bottom_right":
						if player2:
							move_dir = 1
						pass
					_:
						move_dir = 0
		
	
	if not touch_controls:
		if not player2:
			move_dir = Input.get_axis("up", "down")
		else:
			move_dir = Input.get_axis("ui_up", "ui_down")
		
	return move_dir

func _input(event: InputEvent):
	if event is InputEventScreenDrag:
		var target = 'p1' if event.index == 0 else 'p2'
		touch_events[target].position = event.position
	
	if event is InputEventScreenTouch:
		var target = 'p1' if event.index == 0 else 'p2'
		touch_events[target].pressed = event.pressed
	pass
	
func handle_fire(p2):
	if not p2:
		# TODO: Maybe change paddle color, do some shit
		if shot_enabled:
			GameManager.gain_charge.emit("p1", true)
			print("Fire1")
	else:
		# TODO: Maybe change paddle color, do some shit
		if shot_enabled:
			GameManager.gain_charge.emit("p2", true)
			print("Fire2")
	pass
	
func gain_charge(who: String, amount: int, can_fire: bool):
	if who != "p2" and not player2:
		shot_charge = amount
		shot_enabled = can_fire
	else:
		shot_charge = amount
		shot_enabled = can_fire
		
	print(who + " shot_charge = " + str(amount) + " " + " \n shot_enabled = " + str(shot_enabled))
	pass

func _on_top_hitbox_body_entered(body):
	body.offset_dir = -1
	pass # Replace with function body.


func _on_bottom_hitbox_body_entered(body):
	body.offset_dir = 1
	pass # Replace with function body.
