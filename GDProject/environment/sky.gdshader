shader_type spatial;
render_mode unshaded;

group_uniforms skybox;
uniform float environment_multiplier = 1.0;
uniform sampler2D environmentMap;

group_uniforms colorCorrection;
uniform float brightness = 0.0;
uniform float saturation = 1.0; 
uniform float contrast = 1.0;

varying vec4 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0));
}

void fragment() {
	// Obtain skybox
	vec4 pixel_world_pos = (1.0 / world_position.w) * world_position;
	vec3 dir = normalize(pixel_world_pos.xyz - CAMERA_POSITION_WORLD);
	float theta = acos(max(-1.0f, min(1.0f, -dir.y)));
	float phi = atan(dir.z, dir.x);
	if(phi < 0.0f)
		phi = phi + 2.0f * PI;
	vec2 lookup = vec2(phi / (2.0 * PI), 1.0 - theta / PI);
	vec3 finalColor = environment_multiplier * texture(environmentMap, lookup).rgb;
	
	// Color correction
	finalColor = (finalColor.rgb - 0.5f) * (contrast) + 0.5f;
	finalColor = finalColor + brightness;
	finalColor = mix(vec3(dot(finalColor, vec3(0.299, 0.587, 0.114))), finalColor, saturation);
	ALBEDO = finalColor;
}