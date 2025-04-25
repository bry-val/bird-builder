extends Control

@onready var beak_section: VBoxContainer = $BeakSection
@onready var eye_section: VBoxContainer = $EyeSection
@onready var face_section: VBoxContainer = $FaceSection
@onready var feet_section: VBoxContainer = $FeetSection
@onready var tail_section: VBoxContainer = $TailSection
@onready var topper_section: VBoxContainer = $TopperSection

@onready var left_button: Button = $LeftButton
@onready var right_button: Button = $RightButton

# Array to hold all the section containers for easy indexing
var sections: Array[VBoxContainer] = []

# Index of the currently visible section
var current_section_index: int = 0

func _ready():
	# Populate the sections array
	sections.append(beak_section)
	sections.append(eye_section)
	sections.append(face_section)
	sections.append(feet_section)
	sections.append(tail_section)
	sections.append(topper_section)

	# Check if sections array is not empty before proceeding
	if sections.is_empty():
		printerr("No section containers found or added to the 'sections' array.")
		return # Prevent errors later if no sections exist

	# Connect the button signals to the handler functions
	# Ensure the buttons actually exist before connecting
	if left_button:
		left_button.pressed.connect(_on_left_button_pressed)
	else:
		printerr("LeftButton node not found. Check the node path.")

	if right_button:
		right_button.pressed.connect(_on_right_button_pressed)
	else:
		printerr("RightButton node not found. Check the node path.")

	# Initialize visibility: show the first section, hide others
	_update_section_visibility()

# Function to handle the "Left" button press
func _on_left_button_pressed():
	if sections.is_empty(): return # Don't do anything if there are no sections

	# Decrement index
	current_section_index -= 1

	# Wrap around if index goes below 0
	if current_section_index < 0:
		current_section_index = sections.size() - 1

	# Update which section is visible
	_update_section_visibility()

# Function to handle the "Right" button press
func _on_right_button_pressed():
	if sections.is_empty(): return # Don't do anything if there are no sections

	# Increment index
	current_section_index += 1

	# Wrap around if index goes beyond the last element
	if current_section_index >= sections.size():
		current_section_index = 0

	# Update which section is visible
	_update_section_visibility()

# Helper function to set the visibility of sections based on the current index
func _update_section_visibility():
	if sections.is_empty(): return # Safety check

	for i in range(sections.size()):
		# Make the section visible only if its index matches the current_section_index
		sections[i].visible = (i == current_section_index)
