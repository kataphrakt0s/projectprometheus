class_name Selectable extends Node2D

@export var selection_name: String
@export var ui_texture: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## Captures a canvas item as a ViewportTexture.
func capture_canvas_item(canvas_item: CanvasItem) -> ImageTexture:
	# Create temporary viewport
	var viewport = SubViewport.new()
	viewport.size = Vector2i(32,32)
	viewport.transparent_bg = true
	
	# Create duplicate of the node tree
	var duplicate_tree = canvas_item.duplicate()
	viewport.add_child(duplicate_tree)
	
	# Add to scene tree temporarily
	get_tree().root.add_child.call_deferred(viewport)
	
	# Force render update
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame  # Wait for render
	await get_tree().process_frame 
	
	# Get the texture
	var texture = viewport.get_texture()
	
	# Verify texture
	if texture.get_image().is_empty():
		push_error("Viewport texture is empty!")
		return null
		
	var image = texture.get_image()
	var image_texture = ImageTexture.create_from_image(image)
	
	# Clean up
	viewport.queue_free()
	
	return image_texture
