shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.2, 0.21, 0.23, 1.0);
uniform float metal_mix : hint_range(0.0, 1.0) = 0.6;
uniform float rust_amount : hint_range(0.0, 1.0) = 0.3;
uniform float wear_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float pattern_scale : hint_range(1.0, 50.0) = 15.0;
uniform float pattern_line_thickness : hint_range(0.0, 0.1) = 0.02;

// Hash amélioré pour plus de netteté
float hash21(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    // Interpolation plus nette
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(hash21(i), hash21(i + vec2(1.0, 0.0)), u.x),
        mix(hash21(i + vec2(0.0, 1.0)), hash21(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
}

float industrial_pattern(vec2 uv) {
    vec2 grid = fract(uv * pattern_scale);

    // Lignes plus nettes
    float lines_x = smoothstep(0.0, pattern_line_thickness, grid.x) *
                    smoothstep(1.0, 1.0 - pattern_line_thickness, grid.x);
    float lines_y = smoothstep(0.0, pattern_line_thickness, grid.y) *
                    smoothstep(1.0, 1.0 - pattern_line_thickness, grid.y);

    // Crée des bords nets
    float pattern = mix(lines_x, 1.0, lines_y);
    return 1.0 - pattern; // Inverse pour avoir des lignes sombres
}

void fragment() {
    vec2 uv = UV;

    // Motif de base plus net
    float pattern = industrial_pattern(uv);

    // Couleur de base
    vec3 color = base_color.rgb;

    // Variation métallique plus définie
    float metal_pattern = noise(uv * 20.0);
    metal_pattern = pow(metal_pattern, 1.5); // Plus de contraste

    // Usure plus définie
    float wear = pow(noise(uv * 8.0), 1.2) * wear_intensity;

    // Rouille avec bords plus nets
    float rust = smoothstep(0.3, 0.7, noise(uv * 6.0)) * rust_amount;
    vec3 rust_color = vec3(0.4, 0.15, 0.1);

    // Application des effets
    color = mix(color, rust_color, rust * wear);
    color = mix(color * 0.6, color, pattern); // Contraste plus fort pour les lignes

    // Variation d'usure plus subtile
    color *= mix(0.95, 1.05, wear);

    // Rendu final
    ALBEDO = color;
    METALLIC = mix(0.9, 0.3, rust) * metal_mix * (1.0 - pattern * 0.5);
    ROUGHNESS = mix(
        mix(0.4, 0.8, wear), // Surface usée
        0.95,                 // Joints plus rugueux
        pattern
    );

    // Normal mapping plus prononcé
    vec2 noffset = vec2(0.01, 0.01);
    vec2 noise_normal = vec2(
        noise((uv + noffset.xy) * 25.0) - noise((uv - noffset.xy) * 25.0),
        noise((uv + noffset.yx) * 25.0) - noise((uv - noffset.yx) * 25.0)
    );
    NORMAL = normalize(vec3(noise_normal * mix(0.2, 0.4, wear), 1.0));

    // AO plus contrasté
    AO = mix(0.5, 1.0, smoothstep(0.0, 1.0, pattern));
}