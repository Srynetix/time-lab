extends KinematicBody2D
class_name TimeBomb

signal timeout()

export var initial_time: float = 30
export var freeze_time: float = 2

onready var timer: Timer = $Timer
onready var freeze_timer: Timer = $FreezeTimer
onready var label: Label = $Label
onready var animation_player: AnimationPlayer = $AnimationPlayer

var _remaining_time: float = 0

func _ready() -> void:
    _remaining_time = initial_time
    _update_label()

    timer.wait_time = initial_time
    timer.connect("timeout", self, "_on_timer_timeout")

    freeze_timer.wait_time = freeze_time
    freeze_timer.connect("timeout", self, "_on_freeze_timer_timeout")

func _process(_delta: float) -> void:
    if !timer.is_stopped():
        _remaining_time = timer.time_left
        _update_label()

func activate() -> void:
    timer.start()
    animation_player.play("running")

func freeze() -> void:
    timer.paused = true
    freeze_timer.start()
    animation_player.play("freezed")

    for node in get_tree().get_nodes_in_group("turret"):
        var turret: Turret = node
        turret.freeze()

    for node in get_tree().get_nodes_in_group("bullet"):
        var bullet: Bullet = node
        if bullet.hurt_player:
            bullet.freeze()

func stop() -> void:
    timer.paused = true
    freeze_timer.stop()
    animation_player.play("freezed")

func _update_label() -> void:
    label.text = ("%02.02f" % _remaining_time).replace(".", "'")

func _on_timer_timeout() -> void:
    if timer.paused:
        return

    emit_signal("timeout")

func _on_freeze_timer_timeout() -> void:
    timer.paused = false

    for node in get_tree().get_nodes_in_group("turret"):
        var turret: Turret = node
        turret.unfreeze()

    for node in get_tree().get_nodes_in_group("bullet"):
        var bullet: Bullet = node
        if bullet.hurt_player:
            bullet.unfreeze()

    animation_player.play("running")