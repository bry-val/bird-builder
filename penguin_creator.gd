extends Node2D
# Script attached to PenguinCreator (Node2D)

@onready var body: Sprite2D = $body

# Group name used for the part selection buttons
const PART_SELECTOR_GROUP = "part_selector_buttons"

func _ready():
	# Get all nodes belonging to the specified group within the current scene tree
	var buttons = get_tree().get_nodes_in_group(PART_SELECTOR_GROUP)

	if buttons.is_empty():
		print("No buttons found in group '%s'. Check button group assignments." % PART_SELECTOR_GROUP)

	# Iterate through the found buttons and connect their 'pressed' signal
	for button in buttons:
		# Ensure the node is actually a button before connecting
		if not button is Button:
			printerr("Node '%s' in group '%s' is not a Button!" % [button.name, PART_SELECTOR_GROUP])
			continue # Skip to the next node

		# Connect the signal.
		# .bind(button) tells Godot to pass the 'button' variable itself
		# as the first argument when calling _on_part_button_pressed.
		button.pressed.connect(_on_part_button_pressed.bind(button))
		print("Connected button: %s" % button.name)


# --- Central Function to Handle Part Selection ---
# (This function remains the same as before)
func _on_part_button_pressed(button_node: Button):
	# Retrieve the category and part name stored in the button's metadata
	var category_name: String = button_node.get_meta("category", "") # Default to empty string if meta not found
	var part_name: String = button_node.get_meta("part", "")       # Default to empty string if meta not found

	if category_name.is_empty():
		printerr("Button '%s' is missing 'category' metadata!" % button_node.name)
		return

	# Find the category node
	var category_node: Node = body.find_child(category_name, false, false)

	if not category_node:
		printerr("Category node '%s' not found under 'body'!" % category_name)
		return

	# Iterate through all children (parts) within that category node
	for part_node in category_node.get_children():
		if part_node is Sprite2D:
			part_node.visible = (part_node.name == part_name)

	print("Set category '%s' to part '%s'" % [category_name, part_name if not part_name.is_empty() else "none"])

# (Delete old specific functions like _on_beak_normal_pressed etc.)
