shader_type canvas_item;

uniform vec4 vignette_color : source_color = vec4(0.8, 0.8, 0.8, 0.8);
uniform float inner_radius : hint_range(0.0, 1.0) = 0.2;
uniform float outer_radius : hint_range(0.0, 1.0) = 0.6;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// Calculamos la distancia desde el centro (0.5, 0.5)
	float dist = distance(UV, vec2(0.5, 0.5));
	
	// Creamos la transición suave entre el radio interno y el externo
	// Invertimos el resultado para que el centro sea transparente
	float mask = smoothstep(inner_radius, outer_radius, dist);
	
	// Aplicamos la opacidad general y el color
	COLOR = vec4(vignette_color.rgb, mask * vignette_color.a * vignette_opacity);
}