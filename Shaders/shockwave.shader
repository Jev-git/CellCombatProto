shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float radius;
uniform float thickness;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(radius - thickness, radius, length(scaledUV - center)))
		* smoothstep(radius - thickness - 0.1, radius - thickness, length(scaledUV - center));
	vec2 direction = normalize(scaledUV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - direction);
}