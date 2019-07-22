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