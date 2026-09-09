shader_type canvas_item;

// --- MÁSCARA OPCIONAL ---
uniform bool use_mask = false;
uniform sampler2D mask_texture : hint_default_white, filter_nearest;
// Controla qué tan difuminado es el borde de la máscara (0.0 = borde duro, 0.05 = borde muy suave)
uniform float mask_softness : hint_range(0.0, 0.1) = 0.02;

// --- APARIENCIA DE NIEBLA ---
uniform vec4 fog_color : source_color = vec4(0.45, 0.55, 0.5, 0.85);
uniform float density : hint_range(0.0, 1.0) = 0.75;

// --- RUIDO Y MOVIMIENTO ---
uniform float speed : hint_range(0.0, 0.5) = 0.05;
uniform vec2 move_direction = vec2(1.0, 0.5);
uniform float noise_scale : hint_range(1.0, 50.0) = 6.0;

// --- PIXEL ART ---
uniform float pixel_size : hint_range(16.0, 1024) = 128.0;
uniform float alpha_steps : hint_range(1.0, 100.0) = 4.0;

// --- MARGEN Y DIFUMINADO DEL POLÍGONO BASE ---
uniform float edge_fade_distance : hint_range(0.01, 0.5) = 0.2;

// Funciones de ruido FBM clásico
float rand(vec2 coord) {
	return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 coord) {
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 coord) {
	float value = 0.0;
	float scale = 0.5;
	for (int i = 0; i < 4; i++) {
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

// Función para suavizar la lectura de la máscara tomando muestras adyacentes
float get_smoothed_mask(vec2 uv) {
	if (mask_softness <= 0.001) {
		return texture(mask_texture, uv).a;
	}

	float alpha_accum = 0.0;
	vec2 off = vec2(mask_softness);

	// Muestreo en grilla 3x3 para suavizar los bordes de la máscara
	alpha_accum += texture(mask_texture, uv + vec2(-off.x, -off.y)).a;
	alpha_accum += texture(mask_texture, uv + vec2(0.0, -off.y)).a;
	alpha_accum += texture(mask_texture, uv + vec2(off.x, -off.y)).a;
	alpha_accum += texture(mask_texture, uv + vec2(-off.x, 0.0)).a;
	alpha_accum += texture(mask_texture, uv).a;
	alpha_accum += texture(mask_texture, uv + vec2(off.x, 0.0)).a;
	alpha_accum += texture(mask_texture, uv + vec2(-off.x, off.y)).a;
	alpha_accum += texture(mask_texture, uv + vec2(0.0, off.y)).a;
	alpha_accum += texture(mask_texture, uv + vec2(off.x, off.y)).a;

	return alpha_accum / 9.0;
}

void fragment() {
	// 1. Pixelado de coordenadas UV
	vec2 grid_uv = round(UV * pixel_size) / pixel_size;

	// --- LECTURA DE MÁSCARA OPCIONAL ---
	float mask_alpha = 1.0;
	if (use_mask) {
		mask_alpha = get_smoothed_mask(grid_uv);
		if (mask_alpha < 0.001) {
			discard;
		}
	}

	// 2. Cálculo de la distancia a los bordes del polígono base
	vec2 dist_to_edge = min(grid_uv, vec2(1.0) - grid_uv);
	float border_distance = min(dist_to_edge.x, dist_to_edge.y);

	// Máscara de suavizado hacia los bordes
	float edge_mask = smoothstep(0.0, edge_fade_distance, border_distance);

	// 3. Movimiento orgánico con FBM desplazado
	vec2 motion = normalize(move_direction) * TIME * speed;
	vec2 noise_coord = (grid_uv * noise_scale) + motion;

	float distortion = fbm(noise_coord + vec2(fbm(noise_coord)));
	float final_noise = fbm(noise_coord + distortion);

	// 4. Combinación de opacidades
	float alpha = final_noise * density * edge_mask * mask_alpha;

	// 5. Quantización de alpha para Pixel Art
	alpha = floor(alpha * alpha_steps) / alpha_steps;

	COLOR = vec4(fog_color.rgb, alpha);
}