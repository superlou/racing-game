extends Resource
class_name Circuit

@export var sequence:Dictionary[String, String]


func checkpoints_connect(from:String, to:String) -> bool:
    var checkpoint_connections := sequence[from]

    if checkpoint_connections == "":
        var index := sequence.keys().find(from)
        var next_index = (index + 1) % len(sequence)
        var next_key = sequence.keys()[next_index]
        return next_key == to

    # todo Handle specified checkpoints or multiple connections

    return false


func is_first_checkpoint(name:String) -> bool:
    return sequence.keys()[0] == name


func is_end_of_lap(name:String) -> bool:
    return sequence.keys()[-1] == name