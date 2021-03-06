extends Area2D
class_name ExitDoor

export var initial_opened: bool = false

var is_exit := true
var opened: bool = false setget _set_opened

onready var animation_player: AnimationPlayer = $AnimationPlayer

func activate() -> void:
    opened = initial_opened

func _set_opened(value: bool) -> void:
    if opened == value:
        return

    opened = value
    if opened:
        animation_player.play("opened")
    else:
        animation_player.play("closed")