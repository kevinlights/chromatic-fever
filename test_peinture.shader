shader_type canvas_item;

uniform sampler2D effacements;

void fragment(){
	vec4 e = texture(effacements,UV);
	if(e.r==1.0){
		COLOR.a = 0.0;
	}
	else{
		COLOR = texture(TEXTURE,UV);
		COLOR.a = (1.0-e.r)*COLOR.a;
	}
}