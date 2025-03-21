extends CharacterBody2D

@export var speed := 4

func _ready():
	velocity = Vector2(-speed, 2)

func _physics_process(delta):
	var collision := move_and_collide(velocity)
	var colliding_body: Object
	
	
	if(collision):
		var normal := collision.get_normal()
		velocity = velocity.bounce(normal)
		
		# Not sure what to do with this yet but I can get values from it.
		colliding_body = collision.get_collider()
		if colliding_body.get("name") == "Player":
			speed += 0.5
			velocity.x += speed
	pass
