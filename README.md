# TileMap-Raycast
A workaround for the missing One-Way-Collider detection for Raycasts in TileMaps in Godot



#Usage:

Add a custom data layer to your TileMap with a field called "One Way" of type Vector2. Set this Vector to the collision normal for all one-way-collision tiles in your tile set.

Use the TileMapRaycast scene as you would the default Raycast2D node
