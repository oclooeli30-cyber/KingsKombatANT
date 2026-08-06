extends CharacterBody2D


@onready var FOX = $AnimatedSprite2D
@onready var PLAYER = get_tree().get_first_node_in_group("Characters")
var push : float
var LIFE := 3
@onready var HEART = $Lives

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction := 1
var hurtfreeze := false

func _ready() -> void:
	HEART.visible = false
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not hurtfreeze:
		velocity += get_gravity() * delta
		if velocity.y > 0:
			FOX.play("up")
		else:
			FOX.play("down")
	if is_on_wall() and not hurtfreeze:
		velocity.x *= -1
		direction *= -1

	
	
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if velocity.x > 0:
		FOX.flip_h = false
	elif velocity.x < 0:
		FOX.flip_h = true
	if not hurtfreeze:
		velocity.x = 20
		velocity.x = direction * SPEED
	if is_on_floor() and velocity.x != 0 and not hurtfreeze: 
		FOX.play("run")

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if PLAYER.attacking == true:
		velocity.x = 0 
		hurtfreeze = true
		
		if LIFE > 1:
			FOX.play("hit")
			HEART.visible = true
			LIFE -= 1
			if LIFE == 2:
				HEART.play('fulltohalf')
			if LIFE == 1:
				HEART.play('halftoempty')
			await FOX.animation_finished
			
			hurtfreeze = false
		else:
			
			FOX.play("die")
			HEART.play('emptygone')
			await FOX.animation_finished
			queue_free()
		velocity.x += push * -200
		velocity.y = -JUMP_VELOCITY / 2
		velocity.x = 0	
	else:
		PLAYER.damage()	
		print("hi")
		
		
