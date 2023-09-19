extends Node2D
class_name TileMapRaycast

const CUSTOM_DATA_KEY= "One Way"

@onready var ray_cast_2d = $RayCast2D

@export var target_position: Vector2

@export var tile_map: TileMap

var colliding:= false
var collision_point: Vector2
var temp_collision_point= Vector2.ZERO



func is_colliding():
	update_raycast()
	return colliding

func get_collision_point():
	update_raycast()
	return collision_point

func update_raycast():
	colliding= false
	collision_point= Vector2.ZERO
	
	if not target_position:
		return


	var from: Vector2= global_position
	var to: Vector2= global_position + target_position

	while not collision_point:
		temp_collision_point= Vector2.ZERO
		if shoot_single_ray(from, to):
			break
		
		# advance raycast starting position to last hit against one-way-collider and try again
		from= temp_collision_point

	ray_cast_2d.position= Vector2.ZERO

func shoot_single_ray(from: Vector2, to: Vector2)-> bool:
	ray_cast_2d.global_position= from
	ray_cast_2d.target_position= to - from
	
	ray_cast_2d.force_update_transform()
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		# add a little length to the raycast hit so we can be sure we are inside the tile
		# not sure if thats even necessary
		var adjusted_collision_point: Vector2= ray_cast_2d.get_collision_point() + target_position.normalized() * 0.1

		var tile_coords: Vector2i= tile_map.local_to_map(adjusted_collision_point)
		var data= tile_map.get_cell_tile_data(0, tile_coords)
		
		var one_way_dir: Vector2= data.get_custom_data(CUSTOM_DATA_KEY)
		
		# Collide if custom data "One Way" isn't set or pointing in the same direction
		if not one_way_dir or one_way_dir.dot(target_position.normalized()) > 0:
			colliding= true
			collision_point= ray_cast_2d.get_collision_point()
			return true
	
		# There has been a collision but against a one-way-collider in the pass-through direction
		temp_collision_point= adjusted_collision_point
		return false
	
	collision_point= to
	return false



