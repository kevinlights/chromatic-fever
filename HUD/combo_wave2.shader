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

uniform float rainbow_speed = 2;

uniform sampler2D r_tex;

void fragment(){
	vec2 wave_offset;
	vec3 rainbow_offset;

	vec3 c = texture(r_tex,vec2(TIME*rainbow_speed,0)).rgb;
	COLOR = texture(TEXTURE,UV) * vec4(c,1);
}