extends CharacterBody2D

@export var speed = 8000
@export var player2 = false
@export var touch_controls = false

var shot_enabled = false
var shot_charge := 0.0

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

func _physics_process(delta):
	velocity.y = handle_input_dir() * speed * delta
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
				# now we do some stuff with it
				match coord:
					"top_left":
						if not player2:
							move_dir = -1
						# player 1 paddle movement
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
		var index: int = event.index
		var target = 'p1' if index == 0 else 'p2'
		touch_events[target].position = event.position
		pass
	
	if event is InputEventScreenTouch:
		var index: int = event.index
		var target = 'p1' if index == 0 else 'p2'
		touch_events[target].pressed = event.pressed
	pass

func _on_button_pressed():
	if not player2:
		print_debug("FIRING DA LAZA")
		shot_enabled = true
	pass # Replace with function body.
