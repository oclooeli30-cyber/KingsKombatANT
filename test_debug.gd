extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")

    for i in range(80):
        await physics_frame

    fox.direction = 0
    fox.global_position = player.global_position + Vector2(16, 0)
    for i in range(3):
        await physics_frame

    print("1. overlap adjacent: ",
          fox.get_node("Area2D").get_overlapping_areas().has(player.get_node("EnemyDetector")))

    print("2. attack hits fox")
    print("   fox LIFE before=", fox.LIFE)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(60):
        await physics_frame
    print("   fox LIFE after=", fox.LIFE, " player attacking reset=", player.attacking == false)

    print("3. second hit kills fox (ignore knockback by re-parking)")
    fox.LIFE = 1
    fox.hurtfreeze = false
    fox.global_position = player.global_position + Vector2(16, 0)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(120):
        await physics_frame
    print("   fox alive after lethal: ", is_instance_valid(fox))

    print("4. player touch damage")
    print("   player LIFE before=", player.LIFE)
    player.invis = 0
    player.hurtfreeze = false
    var hp = player.global_position
    player.global_position = fox.global_position if is_instance_valid(fox) else hp + Vector2(20, 0)
    for i in range(120):
        await physics_frame
    print("   player LIFE after=", player.LIFE)

    print("TEST DONE")
    quit()
