extends Node3D

@onready var area3d:Area3D = $Area3D


func _physics_process(delta: float) -> void:
    if not area3d.has_overlapping_bodies():
        return
    
    for body in area3d.get_overlapping_bodies():
        body.apply_central_force(1000.0 * (global_basis * Vector3.FORWARD))