extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")
    var hitbox = fox.get_node("Area2D")

    print("--- hold fox overlapping player's EnemyDetector ---")
    for i in range(8):
        fox.global_position = player.global_position
        await physics_frame

    print("fox area overlaps player EnemyDetector: ",
          hitbox.get_overlapping_areas().has(player.get_node("EnemyDetector")))

    print("--- player attacks while overlapping ---")
    print("fox LIFE before=", fox.LIFE, " attacking=", player.attacking)
    player.invis = 0
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(20):
        fox.global_position = player.global_position
        await physics_frame
    print("fox LIFE after=", fox.LIFE, " player attacking=", player.attacking)

    print("--- player damage (clear invis first) ---")
    player.invis = 0
    var before = player.LIFE
    player.damage()
    for i in range(10):
        await process_frame
    print("player LIFE ", before, " -> ", player.LIFE)

    print("TEST DONE")
    quit()
