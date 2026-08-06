extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")
    var fox_area = fox.get_node("Area2D")

    print("--- signals present in enemy scene ---")
    var cons = fox_area.get_signal_connection_list("body_entered")
    for c in cons:
        print("body_entered -> ", c.callable)
    print("player methods: damage=", player.has_method("damage"),
          " _on_area_2d_body_entered=", player.has_method("_on_area_2d_body_entered"),
          " _on_animated_sprite_2d_animation_finished=", player.has_method("_on_animated_sprite_2d_animation_finished"),
          " _on_area_2d_body_exited=", player.has_method("_on_area_2d_body_exited"))

    fox_area.area_entered.connect(func(a): print("FOX AREA_ENTERED: ", a.name, " (parent: ", a.get_parent().name, ")"))
    fox_area.body_entered.connect(func(b): print("FOX BODY_ENTERED: ", b.name))

    print("--- moving fox onto player ---")
    fox.global_position = player.global_position
    for i in range(8):
        await physics_frame

    print("--- simulating player attack overlap ---")
    var enemy_det = player.get_node("EnemyDetector")
    print("EnemyDetector layer=", enemy_det.collision_layer, " mask=", enemy_det.collision_mask)
    print("fox Area2D layer=", fox_area.collision_layer, " mask=", fox_area.collision_mask)
    print("player attacking=", player.attacking, " LIFE=", player.LIFE)

    print("TEST DONE")
    quit()
