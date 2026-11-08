extends CharacterBody3D

@export_group("Camera Settings")
@export var mouse_sensitivity: float = 0.002 

@export_group("Player Movement")
@export var speed: float = 5.0

@onready var camera: Camera3D = %Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("MOV_LEFT", "MOV_RIGHT", "MOV_UP", "MOV_DOWN")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, * delta)
		velocity.z = move_toward(velocity.z, 0, * delta)
		
	move_and_slide()
