extends Node2D
class_name HealthComponent

@export var health : float
@export var max_health : float

@export var AICoreComponent: Node2D

func die():
    print("Organism '" + get_parent().name + "' died.")
    get_parent().queue_free()
    # TODO add organism death

func take_damage(damage : float, attacker : Node):
    health -= damage
    if health <= 0:
        die()
    if attacker != null:
        AICoreComponent.genetic_component.genes[0] += 0.001
        if AICoreComponent.genetic_component.genes[0] > 0.5:
            AICoreComponent.set_target(attacker)
            AICoreComponent.current_state = AICoreComponent.STATES.ENGAGING
    else:
        AICoreComponent.navigation.set_navigation_target(get_parent().position + Vector2(randf_range(-200,200), randf_range(-200,200)))


