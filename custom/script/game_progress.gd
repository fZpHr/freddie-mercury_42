extends Node

enum LevelStatus { LOCKED, UNLOCKED, COMPLETED }

var levels = {
	"tutorial": {
		"name": "Tutorial",
		"status": LevelStatus.UNLOCKED,
		"position": Vector3(0, 202, 0),
		"completed": false
	},
	"level1": {
		"name": "Level 1",
		"status": LevelStatus.LOCKED,
		"position": Vector3(5, 2, 5),
		"completed": false
	},
	"level2": {
		"name": "Level 2",
		"status": LevelStatus.LOCKED,
		"position": Vector3(1, 15.5, 9),
		"completed": false
	}
}

func _ready():
	load_progress()

func reset_progress():
	levels = {
		"tutorial": {
			"name": "Tutorial",
			"status": LevelStatus.UNLOCKED,
			"position": Vector3(5, 2, 5),
			"completed": false
		},
		"level1": {
			"name": "Level 1",
			"status": LevelStatus.LOCKED,
			"position": Vector3(15, 2, 15),
			"completed": false
		},
		"level2": {
			"name": "Level 2",
			"status": LevelStatus.LOCKED,
			"position": Vector3(25, 2, 25),
			"completed": false
		}
	}
	save_progress()

func complete_level(level_id: String):
	if level_id in levels:
		levels[level_id].completed = true
		levels[level_id].status = LevelStatus.COMPLETED
		var next_level = _get_next_level(level_id)
		if next_level:
			levels[next_level].status = LevelStatus.UNLOCKED
	save_progress()

func is_level_available(level_id: String) -> bool:
	return level_id in levels and levels[level_id].status != LevelStatus.LOCKED

func _get_next_level(current_level: String) -> String:
	match current_level:
		"tutorial": return "level1"
		"level1": return "level2"
		_: return ""

func save_progress():
	var save_data = {
		"levels": levels
	}
	var save_file = FileAccess.open("user://game_progress.save", FileAccess.WRITE)
	save_file.store_var(save_data)

func load_progress():
	if FileAccess.file_exists("user://game_progress.save"):
		var save_file = FileAccess.open("user://game_progress.save", FileAccess.READ)
		var save_data = save_file.get_var()
		levels = save_data.levels
