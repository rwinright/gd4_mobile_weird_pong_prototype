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
		velocity = velocity.clamp(Vector2(-15, -15), Vector2(15, 15))
	pass


func _on_area_2d_body_entered(body):
	velocity.x += 0.5
	pass # Replace with function body.
