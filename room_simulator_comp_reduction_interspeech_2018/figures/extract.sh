#!/bin/bash
dia --export=room_diagram.png --filter=png room_diagram.dia
convert recording_room.dia -roate 90 recording_room_rotated.dia
