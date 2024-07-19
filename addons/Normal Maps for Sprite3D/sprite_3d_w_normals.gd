@tool
class_name Sprite3DwNormals extends Sprite3D

## Sprite3D whith Animations and Normal Maps.
## Expecially made for PixelArt  

@export var normal: Texture2D: ## Texture3D object to draw as a Normal Map
	set(value):
		normal = value
		print(normal)
		if normal != null:
			material_override.normal_texture = load(normal.resource_path)
		else:
			material_override.normal_texture = null

@export_category("Create Frame Animation")

@export var animation_player : AnimationPlayer ## Animation Player where the animation is created
@export var animation_name : String = "default" ## Name of the new animation
@export var animation_row : int = 1 ## The row on which the frame of an animation are located
@export var frame_number : int = 0 ## The number of frames of the animation
@export var frame_duration : int = 120 ## Duration of each frame in milliseconds (ms)

@export var create_animation : bool = false: ## Press this only when everything above is set. I know that this is a checkbox and not a button ;)
	set(value):
		if value == true:
			_create_frame_animation()
			
func _ready() -> void:
	
	if get_material_override() == null:
		var spriteMaterial = StandardMaterial3D.new()
		set_material_override(spriteMaterial)
		material_override.normal_enabled = true
		material_override.set_transparency(1)
		material_override.set_cull_mode(2)
		material_override.set_texture_filter(0) #Set to Nearest for Pixel Art


func _set(property, value):
	if property == "texture":
		if value != null:
			material_override.albedo_texture = load(value.resource_path)
		else:
			material_override.albedo_texture = null

func _create_frame_animation():
	if animation_player == null:
		printerr("The Animation Player Node in not set correctly")
		pass
	else:
		var animation_list = animation_player.get_animation_list()
		
		if animation_list.has(animation_name):
			printerr("There is already an animation with this name")
		else:
			var animation = Animation.new()
			var track_index = animation.add_track(Animation.TYPE_VALUE)
			
			var time : float = 0
			
			var coords : Vector2i = Vector2i(0, animation_row - 1) 
			animation.track_set_path(track_index, String(self.get_path()) + ":frame_coords")
			animation.track_set_interpolation_type(track_index, 0) # Set the interpolation type to nearest for pixel art
			
			for n in range(frame_number):
				
				animation.track_insert_key(track_index, time, coords)
				#animation.track_insert_key(track_index, time, value)
				time += float(frame_duration)/1000
				coords.x += 1
			

			animation.set_length(time)
			animation_player.get_animation_library("").add_animation(animation_name, animation)

