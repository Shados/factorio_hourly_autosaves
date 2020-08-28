GUI = require "lib/gui"

TICKS_PER_MINUTE = 60 * 60
TICKS_PER_HOUR = TICKS_PER_MINUTE * 60

local close_gui_button_handler, debug_print, hourly_autosave, mod_init, mod_print, permissions_error_gui, save_gui, save_shortcut, tagged_save_gui_handler, timestamped_save, tick_to_hours, tick_to_minutes, tick_to_save_name, tick_to_suffix, update_save_interval


main = ->
  -- Default the save name prefix on startup
  script.on_init mod_init

  -- Schedule the save
  script.on_nth_tick settings.global["hourly_autosaves_interval"].value * TICKS_PER_MINUTE, hourly_autosave

  -- React to changes in the hourly_autosaves_interval setting
  script.on_event defines.events.on_runtime_mod_setting_changed, update_save_interval

  -- Register handler for manual save GUI
  script.on_event defines.events.on_lua_shortcut, save_shortcut

  GUI.setup!
  return


mod_init = ->
  -- If the autosave prefix is unset, prompt the player to set it
  if settings.global["hourly_autosaves_prefix"].value == ""
    mod_print {"messages.set_autosaves_prefix"}

  -- Store the initial hourly_autosaves_interval so we can gracefully handle changes mid-game
  if global.autosave_interval == nil
    global.autosave_interval = settings.global["hourly_autosaves_interval"].value
  return


hourly_autosave = (nth_tick_event) ->
  tick = nth_tick_event.tick
  return if tick == 0

  timestamped_save tick
  return


timestamped_save = (tick, suffix) ->
  save_name = tick_to_save_name tick
  if suffix
    save_name ..= "-#{suffix}"

  debug_print {"debug.saving_game", save_name}

  -- Annoyingly, server_save() only works in multiplayer, and auto_save
  -- prepends _autosave- to the save name!
  unless game.is_multiplayer!
    game.auto_save save_name
  else
    game.server_save save_name
  return


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
  return


save_shortcut = (on_lua_shortcut_event) ->
  { :player_index, :prototype_name, :tick } = on_lua_shortcut_event
  return unless prototype_name == "tagged_save"
  player = game.players[player_index]
  -- TODO Devise an actual permissions system? Will the base game one ever be
  -- accessible to mods? Is there an existing inter-mod solution for this?
  if player.admin
    save_gui player, tick
  else
    permissions_error_gui player, {"ha-gui.server_save_permission"}


save_gui = (player, tick) ->
  -- NOTE: There's no way to pause the game while this dialog is up, sadly
  frame = player.gui.screen.add
    type: "frame"
    direction: "vertical"
    caption: {"ha-gui.save_dialog"}
  frame.auto_center = true
  frame.style.horizontally_stretchable = true

  text_frame = frame.add
    type: "frame"
    style: "inside_deep_frame"
    direction: "horizontal"
  text_frame.style.padding = 8
  text_frame.style.horizontally_stretchable = true
  -- Frames don't flow things directly, they create an implicit child flow to
  -- do so; we need vertical_align = center on the child flow, so we create it
  -- explicitly
  text_flow = text_frame.add
    type: "flow"
    direction: "horizontal"
  text_flow.style.vertical_align = "center"
  text_flow.style.horizontally_stretchable = true
  -- NOTE: I *could* do a tick handler to update the save name at every 60s
  -- interval, otherwise it might fall out of date while the player has the GUI
  -- open
  label = text_flow.add
    type: "label"
    caption: {"ha-gui.save_suffix_label", "#{tick_to_save_name tick}-"}
  -- This is a magic combination that prevents the label from elipsising itself
  -- and instead forces its parent wider, sourced from Klonan
  label.style.horizontally_stretchable = false
  label.style.horizontally_squashable = true
  name_field = text_flow.add
    type: "textfield"

  button_flow = frame.add
    type: "flow"
  button_flow.style.top_padding = 8
  button_flow.style.horizontally_stretchable = true
  button_flow.style.vertical_align = "center"
  back_button = button_flow.add
    type: "button"
    caption: {"ha-gui.back_button"}
    style: "back_button"
  pusher = button_flow.add
    type: "empty-widget"
    style: "draggable_space"
  pusher.style.horizontally_stretchable = true
  pusher.style.height = 32
  pusher.drag_target = frame
  save_button = button_flow.add
    type: "button"
    caption: {"ha-gui.save_button"}
    style: "confirm_button"

  -- Register handlers for the buttons & text field
  GUI.register_handler back_button, close_gui_button_handler, frame
  GUI.register_handler save_button, tagged_save_gui_handler,
    defines.events.on_gui_click, frame, name_field
  GUI.register_handler name_field, tagged_save_gui_handler,
    defines.events.on_gui_confirmed, frame, name_field


permissions_error_gui = (player, action) ->
  frame = player.gui.screen.add
    type: "frame"
    direction: "vertical"
    caption: {"ha-gui.permissions_error_dialog"}
  frame.auto_center = true
  text_frame = frame.add
    type: "frame"
    style: "inside_deep_frame"
    direction: "horizontal"
  text_frame.style.padding = 8
  text_frame.add
    type: "label"
    caption: {"ha-gui.permissions_error_text", {"ha-gui.server_save_permission"}}
  button_flow = frame.add
    type: "flow"
  button_flow.style.top_padding = 8
  button_flow.style.horizontally_stretchable = true
  button_flow.style.vertical_align = "center"
  back_button = button_flow.add
    type: "button"
    caption: {"ha-gui.back_button"}
    style: "back_button"
  pusher = button_flow.add
    type: "empty-widget"
    style: "draggable_space_with_no_right_margin"
  pusher.style.horizontally_stretchable = true
  pusher.style.height = 32
  pusher.drag_target = frame

  GUI.register_handler back_button, close_gui_button_handler, frame


close_gui_button_handler = (event, gui_frame) ->
  return unless event.name == defines.events.on_gui_click
  GUI.deregister_handlers gui_frame
  gui_frame.destroy!

tagged_save_gui_handler = (event, event_filter, gui_frame, save_name_field) ->
  return unless event.name == event_filter
  timestamped_save event.tick, save_name_field.text
  GUI.deregister_handlers gui_frame
  gui_frame.destroy!


debug_print = (msg) ->
  mod_print msg if settings.global["hourly_autosaves_debug"].value
  return


mod_print = (msg) ->
  game.print {"", {"messages.hourly_autosaves_name"}, ": ", msg}
  return


tick_to_save_name = (tick) ->
  prefix = settings.global["hourly_autosaves_prefix"].value
  "#{prefix}-#{tick_to_suffix tick}"


tick_to_suffix = (tick) ->
  string.format "%05dh%02dm",
    tick_to_hours tick,
    tick_to_minutes (tick % TICKS_PER_HOUR)


tick_to_hours = (tick) ->
  math.floor tick / TICKS_PER_HOUR


tick_to_minutes = (tick) ->
  math.floor tick / TICKS_PER_MINUTE


main!


return
