extends Node2D
class_name GeneticsHandler

enum GENE {
    AGGRESSION,    # Controls aggressive behavior
    DEFENSE,       # Controls defensive capabilities
    STRENGTH,      # Influences attack power
    SPEED,         # Influences movement speed
    VISION_RANGE,  # New: Controls how far an organism can see
    VISION_ANGLE,   # New: Controls the field of view angle


    ## Organism special traits
 
    DIGSTRENGTH, # Amount of seconds required to dig a tile -- Only for digger classes
    VENOM_POWER, # (Value multiplied by 10) = DPS (ex 0.5 venom power = 5 DPS)
}

@export var genes: Array[float] = []

func _ready():
    var expected_gene_count = len(GENE.keys())
    if genes.size() < expected_gene_count:
    	# This ensures that if new genes are added to the enum,
        # the array is expanded. Existing values are preserved.
        # New elements get a default value.
        var old_size = genes.size()
        genes.resize(expected_gene_count)
        for i in range(old_size, expected_gene_count):
            # Set a default for any newly added gene slots
            # You might want specific defaults based on the gene (e.g., genes[GENE.VISION_RANGE] = 100.0)
            genes[i] = 0.5 # Generic default (0.0 to 1.0 scale)

func get_child_genetics_asexual():
    var child_genes = []
    for i in genes:
        var geneValue = i + randf_range(-0.01,0.01)
        geneValue = clamp(geneValue, 0, 1)
        child_genes.append(geneValue)
    return child_genes

func get_child_genetics_sexual(mategenes : Array):
    var child_genes = []
    
    # It's crucial that both parents have the same number of genes for this logic.
    if genes.size() != mategenes.size():
        printerr("GeneticsHandler: Parent gene arrays have different lengths. Self: %d, Mate: %d. Cannot perform sexual reproduction." % [genes.size(), mategenes.size()])
        return child_genes # Return empty or handle error as appropriate

    for i in range(len(genes)):
        var self_parent_gene_value = genes[i]
        var mate_parent_gene_value = mategenes[i]

        # Calculate contribution from self, including mutation
        var self_contrib = self_parent_gene_value / 2.0 # Use 2.0 for float division
        self_contrib += randf_range(-0.01, 0.01)

        # Calculate contribution from mate, including mutation
        var mate_contrib = mate_parent_gene_value / 2.0 # Use 2.0 for float division
        mate_contrib += randf_range(-0.01, 0.01)
        
        # Average the two mutated contributions
        var child_gene_value = (self_contrib + mate_contrib) / 2.0
        child_gene_value = clamp(child_gene_value, 0.0, 1.0) # Use floats for clamp limits
        child_genes.append(child_gene_value)
    return child_genes