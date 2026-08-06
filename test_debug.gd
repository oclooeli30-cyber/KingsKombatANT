extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")

    print("--- let everyone land on the ground ---")
    for i in range(80):
        await physics_frame
    print("player pos=", player.global_position, " on_floor=", player.is_on_floor())
    print("fox pos=", fox.global_position, " on_floor=", fox.is_on_floor())

    print("--- park fox adjacent to player on the ground ---")
    fox.direction = 0
    fox.global_position = player.global_position + Vector2(16, 0)
    for i in range(3):
        await physics_frame
    var hitbox = fox.get_node("Area2D")
    print("overlap adjacent: ",
          hitbox.get_overlapping_areas().has(player.get_node("EnemyDetector")))

    print("--- attack ---")
    print("fox LIFE before=", fox.LIFE)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(25):
        await physics_frame
    print("fox LIFE after=", fox.LIFE)

    print("--- lethal hit ---")
    fox.LIFE = 1
    fox.hurtfreeze = false
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(45):
        await physics_frame
    print("fox alive after lethal: ", is_instance_valid(fox))

    print("TEST DONE")
    quit()
