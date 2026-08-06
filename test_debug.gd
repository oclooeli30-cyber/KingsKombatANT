extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")
    var hitbox = fox.get_node("Area2D")

    fox.set_physics_process(false)
    fox.set_process(false)

    for offset in [Vector2(16, 0), Vector2(18, 0), Vector2(20, 0), Vector2(24, 0)]:
        fox.global_position = player.global_position + offset
        for i in range(3):
            await physics_frame
        var overlaps = hitbox.get_overlapping_areas()
        print("offset ", offset, " -> hasEnemyDetector=", overlaps.has(player.get_node("EnemyDetector")))

    fox.global_position = player.global_position + Vector2(16, 0)
    for i in range(3):
        await physics_frame
    print("--- attack while adjacent ---")
    print("fox LIFE before=", fox.LIFE)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(25):
        await physics_frame
    print("fox LIFE after=", fox.LIFE, " player attacking=", player.attacking)

    print("--- enemy dies at 0 ---")
    fox.LIFE = 1
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(40):
        await physics_frame
    print("fox valid after lethal hit: ", is_instance_valid(fox))

    print("TEST DONE")
    quit()
