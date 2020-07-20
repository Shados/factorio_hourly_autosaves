default_name = ->
  -- If the autosave prefix is unset, prompt the player to set it
  if settings.global["hourly_autosaves_prefix"].value == ""
    game.print {"messages.set_autosaves_prefix"}

hourly_autosave = (nth_tick_event) ->
  return if nth_tick_event.tick == 0

  prefix = settings.global["hourly_autosaves_prefix"].value
  game_hours = math.floor ((game.tick / 60) / 3600)
  save_name = "#{prefix}-#{game_hours}h"

  -- Annoyingly, server_save() only works in multiplayer, and auto_save
  -- prepends _autosave- to the save name!
  unless game.is_multiplayer!
    game.auto_save(save_name)
  else
    game.server_save(save_name)

-- Default the save name prefix on startup
script.on_init(default_name)

-- Schedule the save every hour (3600 seconds)
script.on_nth_tick(3600 * 60, hourly_autosave)

return
