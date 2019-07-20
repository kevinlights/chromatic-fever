shader_type canvas_item;

uniform vec2 r_offset = vec2(0.003,-0.003);
uniform vec2 g_offset = vec2(-0.003,0.003);
uniform vec2 b_offset = vec2(0.003,0.003);

uniform float scale = 0.0;
uniform float speed = 2.0;

void fragment(){
	vec2 moved_r_offset = r_offset;
	vec2 moved_g_offset = g_offset;
	vec2 moved_b_offset = b_offset;
	moved_r_offset.x = cos(TIME*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	moved_g_offset.x = -cos(TIME-0.3*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	moved_b_offset.x = cos(TIME+0.3*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	
	moved_r_offset.y = sin(TIME*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	moved_g_offset.y = sin(TIME-0.3*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	moved_b_offset.y = -sin(TIME+0.3*speed+(SCREEN_UV.x + SCREEN_UV.y))*scale;
	
	float r = texture(SCREEN_TEXTURE,SCREEN_UV+moved_r_offset).r;
	float g = texture(SCREEN_TEXTURE,SCREEN_UV+moved_g_offset).g;
	float b = texture(SCREEN_TEXTURE,SCREEN_UV+moved_b_offset).b;
	
	COLOR = vec4(r,g,b,1.0);
}