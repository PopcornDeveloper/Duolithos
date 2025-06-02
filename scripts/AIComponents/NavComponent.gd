extends NavigationAgent2D
class_name NavComponent

@export var AICoreComponent : AICoreComponent_LUCA
@export var movement_speed: float = 50.0
@onready var navigation_agent: NavigationAgent2D = self

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_navigation_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var speed_multiplier: float = 1.0 # Default if genetics are not available or SPEED gene is missing
	if AICoreComponent and AICoreComponent.genetic_component and \
	   AICoreComponent.genetic_component.genes.size() > GeneticsHandler.GENE.SPEED:
		speed_multiplier = AICoreComponent.genetic_component.genes[GeneticsHandler.GENE.SPEED]
	else:
		printerr("NavComponent: Could not access SPEED gene for %s" % get_parent().name)
	var new_velocity: Vector2 = get_parent().global_position.direction_to(next_path_position) * movement_speed * speed_multiplier
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	get_parent().move_and_slide()