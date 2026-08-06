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
	HEART.play("full")
	HEART.visible = false


func _process(_delta: float) -> void:
	if invis > 0:
		ANIM.visible = invis % 2 == 1
		invis -= 1
	else:
		ANIM.visible = true
		HEART.visible = false


func _physics_process(delta: float) -> void:
	push = Input.get_axis("left", "right")

	if on_ladder and not hurtfreeze:
		climbing = true
		attacking = false
		velocity.x = 0
		laddery = (Input.is_action_pressed("down") as int) - int(Input.is_action_pressed("jump"))
		velocity.y = laddery * CLIMB_SPEED
		if laddery < 0:
			_play_anim("jump")
		elif laddery > 0:
			_play_anim("fall")
	elif not hurtfreeze:
		climbing = false

		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if Input.is_action_just_pressed("attack") and is_on_floor() and not attacking:
			attacking = true
			ANIM.play("attack")
			SpearSFX.play()

		if attacking:
			velocity.x = 0
		else:
			var direction := Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			if Input.is_action_pressed("sprint"):
				SPEED = 250.0
				sprinting = true
			else:
				sprinting = false
				SPEED = 100.0

			if is_on_floor():
				if abs(velocity.x) > 0:
					_play_anim("sprint" if sprinting else "run")
				else:
					_play_anim("idle")
			else:
				_play_anim("jump" if velocity.y < 0 else "fall")

		if velocity.x < 0:
			ANIM.flip_h = true
		elif velocity.x > 0:
			ANIM.flip_h = false

	move_and_slide()


func _play_anim(anim_name: String) -> void:
	if ANIM.animation != anim_name:
		ANIM.play(anim_name)


func _on_animated_sprite_2d_animation_finished() -> void:
	if attacking and ANIM.animation == "attack":
		attacking = false


func _on_hurt_detector_body_entered(_body: Node2D) -> void:
	damage()


func damage() -> void:
	if invis > 0:
		return

	hurtfreeze = true

	if LIFE > 1:
		attacking = false
		velocity.x = 0
		velocity.x += push * -400
		velocity.y = JUMP_VELOCITY
		ANIM.play("hit")
		HEART.visible = true
		LIFE -= 1
		if LIFE == 2:
			HEART.play('fulltohalf')
		if LIFE == 1:
			HEART.play('halftoempty')
		invis = 200
		await ANIM.animation_finished
	else:
		velocity = Vector2.ZERO
		ANIM.play("die")
		HEART.play('emptygone')
		await ANIM.animation_finished
		get_tree().change_scene_to_file("res://scenes/main.tscn")

	hurtfreeze = false


func _on_ladder_detector_body_entered(_body: Node2D) -> void:
	on_ladder = true


func _on_ladder_detector_body_exited(_body: Node2D) -> void:
	on_ladder = false
