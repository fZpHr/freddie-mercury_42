shader_type spatial;

// Couleurs
uniform vec4 WATER_COLOR : source_color = vec4(0.1, 0.3, 0.6, 1.0);
uniform vec4 HIGHLIGHT_COLOR : source_color = vec4(0.5, 0.7, 0.9, 1.0);

// Paramètres VR-friendly
uniform float WAVE_SPEED : hint_range(0.1, 1.0) = 0.3;
uniform float WAVE_HEIGHT : hint_range(0.0, 0.2) = 0.005;
uniform float WAVE_SCALE = 1.0;

// Fonction de vague simplifiée pour VR
float get_wave(vec2 pos, float time) {
    // Utilisation d'une seule vague pour réduire la charge
    return sin(pos.x * WAVE_SCALE + time * WAVE_SPEED) * 
           cos(pos.y * WAVE_SCALE + time * WAVE_SPEED) * 
           WAVE_HEIGHT;
}

void vertex() {
    // Animation simple des vertex
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    float wave = get_wave(world_pos.xz, TIME);
    VERTEX.y += wave;
    
    // Normales simplifiées
    NORMAL = normalize(vec3(0.0, 1.0, wave));
}

void fragment() {
    // Effet de profondeur simplifié
    float depth = dot(normalize(VIEW), NORMAL) * 0.5 + 0.5;
    
    // Couleur de base avec highlight simple
    vec3 final_color = mix(WATER_COLOR.rgb, HIGHLIGHT_COLOR.rgb, depth);
    
    ALBEDO = final_color;
    METALLIC = 0.5;
    ROUGHNESS = 0.2;
    SPECULAR = 0.3;
}