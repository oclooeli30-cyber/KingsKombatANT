extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")

    print("--- player methods now present ---")
    print("damage=", player.has_method("damage"),
          " _on_area_2d_body_entered=", player.has_method("_on_area_2d_body_entered"),
          " _on_animated_sprite_2d_animation_finished=", player.has_method("_on_animated_sprite_2d_animation_finished"))

    print("--- overlap fox EnemyDetector with player, then attack ---")
    fox.global_position = player.global_position
    for i in range(6):
        await physics_frame

    var overlapped = fox.get_node("Area2D").get_overlapping_areas()
    print("fox area overlaps player EnemyDetector: ", overlapped.has(player.get_node("EnemyDetector")))

    print("fox LIFE before attack=", fox.LIFE)
    player.attacking = true
    player.get_node("AnimatedSprite2D").play("attack")
    for i in range(15):
        await physics_frame
    print("fox LIFE after attack=", fox.LIFE)

    print("--- player takes damage ---")
    var before = player.LIFE
    player.damage()
    for i in range(10):
        await process_frame
    print("player LIFE ", before, " -> ", player.LIFE)

    print("--- attack completes via signal (attacking resets) ---")
    print("player attacking=", player.attacking)

    print("TEST DONE")
    quit()
