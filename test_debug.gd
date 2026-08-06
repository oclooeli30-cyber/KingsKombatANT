extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")
    fox.direction = 0
    fox.global_position = player.global_position + Vector2(16, 0)
    for i in range(5):
        await physics_frame

    print("overlap at start: ",
          fox.get_node("Area2D").get_overlapping_areas().has(player.get_node("EnemyDetector")))

    print("--- attack while adjacent ---")
    print("fox LIFE before=", fox.LIFE)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(25):
        await physics_frame
    print("fox LIFE after=", fox.LIFE, " player attacking=", player.attacking)

    print("--- lethal hit kills fox ---")
    fox.LIFE = 1
    fox.hurtfreeze = false
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(45):
        await physics_frame
    print("fox valid after lethal hit: ", is_instance_valid(fox))

    print("--- attack resets when animation finishes (not stuck) ---")
    print("player attacking=", player.attacking)

    print("TEST DONE")
    quit()
