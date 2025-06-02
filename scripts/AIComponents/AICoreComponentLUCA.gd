extends Node2D
class_name AICoreComponent_LUCA

@export var vision_cast : RayCast2D
@export var genetic_component : GeneticsHandler
@export var navigation : NavComponent

var hunger = 0.0

var target : CharacterBody2D

enum STATES {
    IDLE,
    ATTACKING,
    FLEEING,
    ENGAGING,
    SEARCHING,
    CONSUMING
}
var current_state = STATES.IDLE

func handle_state():
    match current_state:
        STATES.IDLE:
            pass
        STATES.ATTACKING:
            pass # TODO Implement attacking

        STATES.FLEEING:
            navigation.movement_speed = 100.0
            navigation.set_navigation_target(global_position + Vector2(randf_range(-200,200), randf_range(-200,200)))
            
            await get_tree().create_timer(5).timeout

            navigation.movement_speed = 50.0
            current_state = STATES.IDLE
        STATES.ENGAGING:
            if target:
                navigation.set_navigation_target(target.global_position)
        STATES.SEARCHING:
            navigation.set_navigation_target(global_position + Vector2(randf_range(-200,200), randf_range(-200,200)))
            await navigation.target_reached
        STATES.CONSUMING:
            pass

func _process(_delta: float) -> void:
    handle_state()

    if genetic_component.genes[genetic_component.GENE.AGGRESSION] > 0.75:
        if vision_cast.is_colliding():
            var collider = vision_cast.get_collider()
            if collider.is_in_group("land_organism"):
                set_target(collider)

func set_target(attacker : CharacterBody2D):
    target = attacker
    navigation.set_navigation_target(target.global_position)
    current_state = STATES.ENGAGING