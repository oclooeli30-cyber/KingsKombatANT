extends CharacterBody2D


var SPEED = 100.0
const JUMP_VELOCITY = -300.0
const CLIMB_SPEED = 200.0

@onready var ANIM := $AnimatedSprite2D

var sprinting := false
var attacking := false
var climbing : bool
var on_ladder : bool

func _ready() -> void:
	ANIM.animation_finished.connect(_on_animation_finished)
	


func _physics_process(delta: float) -> void:
	if not on_ladder:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if Input.is_action_just_pressed("attack") and is_on_floor() and not attacking:
			attacking = true
			ANIM.play("attack")
		
		if not attacking:
			var direction := Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_pressed("sprint") and attacking == false:
			SPEED = 250.0
			sprinting = true
			ANIM.play("sprint")
		else:
			sprinting = false
			SPEED = 100.0
		

		if not attacking:
			if is_on_floor():
				if abs(velocity.x) > 0:
					if sprinting == false:
						ANIM.play("run")
				else:
					ANIM.play("idle")
			else:
				if velocity.y < 0:
					ANIM.play("jump")
				else:
					ANIM.play("fall")

		if velocity.x < 0:
			ANIM.flip_h = true
		elif velocity.x > 0:
			ANIM.flip_h = false

		move_and_slide()

func _on_animation_finished() -> void:
	attacking = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	on_ladder = true 
	print("entered")
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	on_ladder = false
	ANIM.play("idle")
