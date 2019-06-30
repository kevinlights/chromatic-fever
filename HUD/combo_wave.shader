shader_type canvas_item;

uniform vec2 wave_scale = vec2(0.005,0.002);
uniform float wave_speed = 10.0;

uniform vec3 rainbow_scale = vec3(1.0,1.0,1.0);
uniform float rainbow_speed = 5.0;

void fragment(){
	vec2 wave_offset;
	vec3 rainbow_offset;
	
	wave_offset.x = cos(TIME*wave_speed+(UV.x + UV.y))*wave_scale.x;
	wave_offset.y = sin(TIME*wave_speed+(UV.x + UV.y))*wave_scale.y;
	
	rainbow_offset.x = cos(TIME*rainbow_speed+(UV.x + UV.y)*rainbow_scale.x);
	rainbow_offset.y = sin(TIME*rainbow_speed+(UV.x + UV.y)*rainbow_scale.y);
	rainbow_offset.z = tan(TIME*rainbow_speed+(UV.x + UV.y)*rainbow_scale.z);
	
	COLOR.rgb = rainbow_offset;
	COLOR *= texture(TEXTURE,UV+wave_offset);
}