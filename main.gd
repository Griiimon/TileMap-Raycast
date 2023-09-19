extends Node2D

var do_raycasts:= false

func _ready():
	await get_tree().process_frame
	do_raycasts= true
	queue_redraw()

func _draw():
	if not do_raycasts: return
	
	for child in get_children():
		if child is TileMapRaycast:
			prints(child.name, child.is_colliding())
			draw_line(child.global_position, child.get_collision_point(), Color.GREEN, 5)

