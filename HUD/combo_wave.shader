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