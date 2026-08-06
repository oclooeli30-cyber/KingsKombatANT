extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")

    print("--- lethal hit directly ---")
    fox.LIFE = 1
    fox._take_damage()
    for i in range(60):
        await process_frame
    print("fox alive after lethal: ", is_instance_valid(fox))

    print("--- attack finishes via signal (no stuck state) ---")
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(30):
        await process_frame
    print("player attacking=", player.attacking)

    print("TEST DONE")
    quit()
