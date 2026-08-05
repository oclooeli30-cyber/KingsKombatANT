extends CharacterBody2D


var SPEED = 100.0
const JUMP_VELOCITY = -300.0
const CLIMB_SPEED = 200.0

@onready var ANIM := $AnimatedSprite2D
@onready var SpearSFX := $SpearSFX
@onready var HEART := $Lives

var hurtfreeze := false
var LIFE := 3
var sprinting := false
var attacking := false
var climbing := false
var on_ladder := false
var laddery : int
var push : float
var invis := 0



func _ready() -> void:
	ANIM.animation_finished.connect(_on_animation_finished)
	HEART.play("full")
	HEART.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	on_ladder = true 
	print("entered")
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	on_ladder = false

func _process(delta: float) -> void:
	if invis > 0:
			if invis % 2 == 0:
				ANIM.visible = false
			else:
				ANIM.visible = true
				
			invis -= 1 # Countdown 
	else:
		HEART.visible = false

func _physics_process(delta: float) -> void:
	
	push = Input.get_axis("left", "right")
	
	if not on_ladder and not hurtfreeze:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if Input.is_action_just_pressed("attack") and is_on_floor() and not attacking:
			attacking = true
			ANIM.play("attack")
			SpearSFX.play()
		
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

		
		climbing = false
	elif not hurtfreeze:
		climbing = true
		
		if climbing == true:
			laddery = (Input.is_action_pressed("down") as int) - int(Input.is_action_pressed("jump"))
			velocity.y = laddery * CLIMB_SPEED
			if laddery < 0:
				ANIM.play("jump")
			if laddery > 0:
				ANIM.play("fall")

	move_and_slide()
func _on_animation_finished() -> void:
	attacking = false


func _on_hurt_detector_body_entered(body: Node2D) -> void:
	if invis < 1:
		hurtfreeze = true
		velocity.x = 0 
		velocity.x += push * -400
		velocity.y = JUMP_VELOCITY
		
		if LIFE > 1:
			ANIM.play("hit")
			HEART.visible = true
			LIFE -= 1
			if LIFE == 2:
				HEART.play('fulltohalf')
			if LIFE == 1:
				HEART.play('halftoempty')
			
			invis = 200
			
		else:
			velocity.x += push * -200
			velocity.y = -JUMP_VELOCITY
			await is_on_floor()
			velocity.x = 0
			ANIM.play("die")
			HEART.play('emptygone')
			await ANIM.animation_finished
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		
		await ANIM.animation_finished
		hurtfreeze = false
		print(LIFE)
