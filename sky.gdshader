shader_type sky;

uniform sampler2D source_panorama : filter_linear, source_color, hint_default_black;
uniform float exposure : hint_range(0, 128) = 1.0;
uniform float rotation_speed : hint_range(0.0, 0.5) = 0.000001;

void sky() {
    // Récupération des coordonnées de base
    vec2 sky_uv = SKY_COORDS;

    // Ajout de la rotation (sur l'axe horizontal)
    sky_uv.x = fract(sky_uv.x + TIME * rotation_speed);

    // Application de la texture avec rotation
    COLOR = texture(source_panorama, sky_uv).rgb * exposure;
}