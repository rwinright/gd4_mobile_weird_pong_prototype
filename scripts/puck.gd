extends CharacterBody2D

@export var speed := 4
var offset_dir: float = 0.

func _ready():
	velocity = Vector2(-speed, 0)

func _physics_process(delta):
	var collision := move_and_collide(velocity)
	var colliding_body: Object
	
	
	if(collision):
		var normal := collision.get_normal()
		#makes it so we don't have a lock on a single plane
		if normal.y <= 0:
			velocity.y += randf_range(-0.3, 0.3)
		if normal.x <= 0:
			velocity.x += randf_range(-0.3, 0.3)
		velocity = velocity.bounce(normal)
		velocity.y += offset_dir
		offset_dir = 0
		velocity = velocity.clamp(Vector2(-15, -15), Vector2(15, 15))
		
	pass


func _on_area_2d_body_entered(body):
	velocity.x += 0.5
	pass # Replace with function body.
