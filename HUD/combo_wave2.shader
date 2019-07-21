shader_type canvas_item;

uniform float rainbow_speed = 2;

uniform sampler2D r_tex;

void fragment(){
	vec2 wave_offset;
	vec3 rainbow_offset;

	vec3 c = texture(r_tex,vec2(TIME*rainbow_speed,0)).rgb;
	COLOR = texture(TEXTURE,UV) * vec4(c,1);
}