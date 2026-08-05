extends CharacterBody2D


@onready var FOX = $AnimatedSprite2D
@onready var PLAYER = 

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction := 1


func _process(delta: float) -> void:
	if is_on_wall():
		velocity.x *= -1
		direction *= -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			FOX.play("up")
		else:
			FOX.play("down")
			

	
	
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if velocity.x > 0:
		FOX.flip_h = false
	elif velocity.x < 0:
		FOX.flip_h = true
	
	velocity.x = 20
	velocity.x = direction * SPEED
	if is_on_floor(): 
		FOX.play("run")

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
