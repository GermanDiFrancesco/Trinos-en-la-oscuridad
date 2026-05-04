shader_type canvas_item;

// Colores y transparencia
uniform vec4 fog_color : source_color = vec4(0.5, 0.6, 0.5, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.7;

// Configuración del Ruido (FBM)
uniform int octaves : hint_range(1, 8) = 4;
uniform float speed : hint_range(0.0, 1.0) = 0.1;

// Configuración de la Máscara (El "agujero" central)
uniform float hole_radius : hint_range(0.0, 1.0) = 0.3;
uniform float hole_softness : hint_range(0.0, 1.0) = 0.1;

// --- PARÁMETROS PIXEL ART ---
// Controla el tamaño de los "bloques". Menos valor = más grande el píxel.
uniform float pixel_size : hint_range(16.0, 512.0) = 128.0; 
// Controla cuántos pasos de transparencia hay (ej: 2.0 es binario, 4.0 es más suave)
uniform float alpha_steps : hint_range(1.0, 10.0) = 3.0;

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
	for (int i = 0; i < octaves; i++) {
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment() {
	// Pixelamos las coordenadas antes de cualquier cálculo
	vec2 grid_uv = round(UV * pixel_size) / pixel_size;
	
	// Movimiento
	vec2 coord = grid_uv * 5.0;
	vec2 motion = vec2(fbm(coord + TIME * speed));
	float final_noise = fbm(coord + motion);
	
	// Máscara circular pixelada
	float dist = distance(grid_uv, vec2(0.5, 0.5));
	float circle_mask = smoothstep(hole_radius, hole_radius + hole_softness, dist);
	
	// Aplicamos densidad y posterización de alpha
	float alpha = final_noise * density * circle_mask;
	
	// Este paso es el que le da el look final de "niveles de color" limitados
	alpha = floor(alpha * alpha_steps) / alpha_steps;
	
	COLOR = vec4(fog_color.rgb, alpha);
}