shader_type canvas_item;

uniform float f : hint_range(0, 1);

void fragment(){
	vec4 c = texture(TEXTURE,UV);
	if(c.a !=0.0){
		c.rgb = mix(c.rgb,vec3(1.0,1.0,1.0),f);
	}
	COLOR = c;
}