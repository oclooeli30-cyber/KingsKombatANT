extends CharacterBody2D


@onready var FOX := $AnimatedSprite2D
@onready var HEART := $Lives
@onready var HITBOX := $Area2D

var PLAYER: CharacterBody2D
var LIFE := 3

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction := 1
var hurtfreeze := false


func _ready() -> void:
	HEART.visible = false
	PLAYER = get_tree().get_first_node_in_group("Characters")


func _physics_process(delta: float) -> void:
	if not is_on_floor() and not hurtfreeze:
		velocity += get_gravity() * delta
		if velocity.y > 0:
			_play_anim("up")
		else:
			_play_anim("down")

	if is_on_wall() and not hurtfreeze:
		velocity.x *= -1
		direction *= -1

	if velocity.x > 0:
		FOX.flip_h = false
	elif velocity.x < 0:
		FOX.flip_h = true

	if not hurtfreeze:
		velocity.x = direction * SPEED

	if is_on_floor() and velocity.x != 0 and not hurtfreeze:
		_play_anim("run")

	if not hurtfreeze and PLAYER != null and PLAYER.attacking \
			and HITBOX.get_overlapping_areas().has(PLAYER.get_node("EnemyDetector")):
		_take_damage()

	move_and_slide()


func _play_anim(anim_name: String) -> void:
	if FOX.animation != anim_name:
		FOX.play(anim_name)


func _take_damage() -> void:
	hurtfreeze = true
	velocity.x = -200.0 if PLAYER.global_position.x < global_position.x else 200.0
	velocity.y = -JUMP_VELOCITY / 2

	if LIFE > 1:
		FOX.play("hit")
		HEART.visible = true
		LIFE -= 1
		if LIFE == 2:
			HEART.play('fulltohalf')
		if LIFE == 1:
			HEART.play('halftoempty')
		await FOX.animation_finished
	else:
		FOX.play("die")
		HEART.play('emptygone')
		await FOX.animation_finished
		queue_free()

	hurtfreeze = false
