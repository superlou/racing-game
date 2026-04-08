@tool
extends Node3D

@export_range(0.0, 1.0) var intensity := 0.5
@export var color_map: Gradient = null
@export var frequency_map: Curve = null
@export var strength_map: Curve = null

func _process(_delta: float) -> void:
	var color := color_map.sample(intensity)

	$Light.light_color = color
	var material: ShaderMaterial = $Aura.mesh.material
	material.set_shader_parameter("fire_color", color)

	var noise: Noise = material.get_shader_parameter("noise_tex").noise
	noise.frequency = frequency_map.sample(intensity)

	material.set_shader_parameter("distortion_strength", strength_map.sample(intensity))
