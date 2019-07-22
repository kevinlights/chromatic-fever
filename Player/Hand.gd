"""
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
"""

extends Node2D

func _physics_process(delta):
	var r = int(rad2deg(rotation))%360
	if(r<0):
		r+=360
	if(r>180):
		$HandSprite.z_index = 0
	else:
		$HandSprite.z_index = 2
	if(r>270 or r < 90):
		$HandSprite.flip_v = false
	else:
		$HandSprite.flip_v = true

func shoot():
	$Explosion.play()
	var r = int(rad2deg(rotation))%360
	if(r<0):
		r+=360
	if(r>270 or r < 90):
		$AnimationPlayer.play("shoot")
	else:
		$AnimationPlayer.play("shoot_rev")
