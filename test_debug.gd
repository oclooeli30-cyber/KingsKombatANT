extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")
    var hitbox = fox.get_node("Area2D")

    print("hitbox monitoring=", hitbox.monitoring, " monitorable=", hitbox.monitorable,
          " layer=", hitbox.collision_layer, " mask=", hitbox.collision_mask)
    var det = player.get_node("EnemyDetector")
    print("EnemyDetector monitoring=", det.monitoring, " monitorable=", det.monitorable,
          " layer=", det.collision_layer, " mask=", det.collision_mask)

    for offset in [Vector2.ZERO, Vector2(10, 0), Vector2(14, 0), Vector2(18, 0), Vector2(-10, 0)]:
        fox.global_position = player.global_position + offset
        for i in range(4):
            await physics_frame
        var overlaps = hitbox.get_overlapping_areas()
        var names = []
        for a in overlaps:
            names.append(a.get_parent().name if a.get_parent() else "?")
        print("offset ", offset, " -> overlapping areas: ", names,
              " hasEnemyDetector=", overlaps.has(det))

    print("--- also check det.get_overlapping_areas ---")
    var dnames = []
    for a in det.get_overlapping_areas():
        dnames.append(a.get_parent().name if a.get_parent() else "?")
    print("EnemyDetector overlaps: ", dnames)

    print("TEST DONE")
    quit()
