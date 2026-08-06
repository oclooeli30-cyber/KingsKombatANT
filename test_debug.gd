extends SceneTree

func _init() -> void:
    var level = load("res://scenes/level_0.tscn").instantiate()
    root.add_child(level)
    await process_frame
    await process_frame

    var player = level.get_node("Player")
    var fox = level.get_node("Fox")

    print("--- settle ---")
    for i in range(80):
        await physics_frame
    print("fox on_floor=", fox.is_on_floor())

    fox.LIFE = 1
    print("calling _take_damage, anim=", fox.FOX.animation)
    fox._take_damage()
    print("after call, hurtfreeze=", fox.hurtfreeze, " anim=", fox.FOX.animation)
    fox.FOX.animation_finished.connect(func(): print("FOX animation_finished fired, anim=", fox.FOX.animation))

    for i in range(90):
        await process_frame
        if not is_instance_valid(fox):
            print("fox freed at frame ", i)
            break
    print("fox alive at end: ", is_instance_valid(fox))
    if is_instance_valid(fox):
        print("fox anim=", fox.FOX.animation, " hurtfreeze=", fox.hurtfreeze)

    print("TEST DONE")
    quit()
