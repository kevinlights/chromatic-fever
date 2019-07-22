/*
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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