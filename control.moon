TICKS_PER_MINUTE = 60 * 60
TICKS_PER_HOUR = TICKS_PER_MINUTE * 60

local debug_print, hourly_autosave, mod_init, mod_print, tick_to_hours, tick_to_minutes, tick_to_suffix, update_save_interval

main = ->
  -- Default the save name prefix on startup
  script.on_init mod_init

  -- Schedule the save
  script.on_nth_tick settings.global["hourly_autosaves_interval"].value * TICKS_PER_MINUTE, hourly_autosave

  -- React to changes in the hourly_autosaves_interval setting
  script.on_event defines.events.on_runtime_mod_setting_changed, update_save_interval

mod_init = ->
  -- If the autosave prefix is unset, prompt the player to set it
  if settings.global["hourly_autosaves_prefix"].value == ""
    mod_print {"messages.set_autosaves_prefix"}

  -- Store the initial hourly_autosaves_interval so we can gracefully handle changes mid-game
  if global.autosave_interval == nil
    global.autosave_interval = settings.global["hourly_autosaves_interval"].value


hourly_autosave = (nth_tick_event) ->
  tick = nth_tick_event.tick
  return if tick == 0

  prefix = settings.global["hourly_autosaves_prefix"].value
  save_name = "#{prefix}-#{tick_to_suffix tick}"

  debug_print {"debug.hourly_autosave", save_name}

  -- Annoyingly, server_save() only works in multiplayer, and auto_save
  -- prepends _autosave- to the save name!
  unless game.is_multiplayer!
    game.auto_save save_name
  else
    game.server_save save_name


update_save_interval = (on_runtime_mod_setting_changed_event) ->
  return if on_runtime_mod_setting_changed_event.setting != "hourly_autosaves_interval"

  new_interval = settings.global["hourly_autosaves_interval"].value
  old_interval = global.autosave_interval

  debug_print {"debug.update_save_interval", old_interval, new_interval}

  -- Deregister existing hourly_autosave tick handler
  script.on_nth_tick old_interval * TICKS_PER_MINUTE, nil

  -- Re-register new one
  script.on_nth_tick new_interval * TICKS_PER_MINUTE, hourly_autosave

  global.autosave_interval = new_interval


debug_print = (msg) ->
  mod_print msg if settings.global["hourly_autosaves_debug"].value
  return


mod_print = (msg) ->
  game.print {"", {"messages.hourly_autosaves_name"}, ": ", msg}


tick_to_suffix = (tick) ->
  minutes = tick_to_minutes (tick % TICKS_PER_HOUR)
  if minutes == 0
    "#{tick_to_hours tick}h"
  else
    "#{tick_to_hours tick}h#{minutes}m"


tick_to_hours = (tick) ->
  math.floor tick / TICKS_PER_HOUR


tick_to_minutes = (tick) ->
  math.floor tick / TICKS_PER_MINUTE


main!


return
