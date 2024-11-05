local fs = require("luacheck.fs")
local factorio_config_file = ".luacheckrc.factorio"
local factorio_config_dir = fs.find_file(fs.get_current_dir(), factorio_config_file)
local factorio_config_path = tostring(factorio_config_dir) .. "/" .. tostring(factorio_config_file)
local stds_fd = io.open(factorio_config_path, "r")
local config = (load(stds_fd:read("*a")))()
config.std = "factorio_control_stage"
config.files = {
	['.luacheckrc*'] = {
		std = "lua52"
	},
	['settings.*'] = {
		std = "factorio_data_stage"
	},
	['settings-updates.*'] = {
		std = "factorio_data_stage"
	},
	['settings-final-fixes.*'] = {
		std = "factorio_data_stage"
	},
	['data.*'] = {
		std = "factorio_data_stage"
	},
	['data-updates.*'] = {
		std = "factorio_data_stage"
	},
	['data-final-fixes.*'] = {
		std = "factorio_data_stage"
	},
	['data/'] = {
		std = "factorio_data_stage"
	},
	['prototypes/'] = {
		std = "factorio_data_stage"
	},
	['settings/'] = {
		std = "factorio_data_stage"
	},
	['lib/data*'] = {
		std = "factorio_data_stage"
	},
	['instrument-settings.*'] = {
		std = "factorio_data_stage+factorio_instrument_mode"
	},
	['instrument-data.*'] = {
		std = "factorio_data_stage+factorio_instrument_mode"
	},
	['instrument-after-data.*'] = {
		std = "factorio_data_stage+factorio_instrument_mode"
	},
	['instrument-control.*'] = {
		std = "+factorio_instrument_mode"
	}
}
config.ignore = {
	"21[123]/^_",
	"581"
}
return config
