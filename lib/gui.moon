local GUI, gui_handlers
gui_handlers = {}

-- Provides a proxy for generic GUI event types and dispatches them
-- per-element.
-- This lets me wire up event handlers to specific GUI elements, which I
-- personally find to be a more natural approach.
GUI =
  register_handler: (element, handler, ...) ->
    player_gui_handlers = gui_handlers[element.player_index]
    unless player_gui_handlers
      player_gui_handlers = {}
      gui_handlers[element.player_index] = player_gui_handlers

    params = {...}
    player_gui_handlers[element.index] = {handler, params}


  deregister_handlers: (element) ->
    player_gui_handlers = gui_handlers[element.player_index]
    return unless player_gui_handlers
    player_gui_handlers[element.index] = nil
    -- Recursively deregister handlers for children
    for _, child_element in pairs element.children
      GUI.deregister_handlers child_element

  on_gui_event: (event) ->
    {:element} = event
    return unless (element and element.valid)
    player_gui_handlers = gui_handlers[element.player_index]
    return unless player_gui_handlers
    registration = player_gui_handlers[element.index]
    if registration
      {handler, params} = registration
      handler(event, table.unpack params)

  setup: ->
    script.on_event defines.events.on_gui_checked_state_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_click, GUI.on_gui_event
    script.on_event defines.events.on_gui_closed, GUI.on_gui_event
    script.on_event defines.events.on_gui_confirmed, GUI.on_gui_event
    script.on_event defines.events.on_gui_elem_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_location_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_opened, GUI.on_gui_event
    script.on_event defines.events.on_gui_selected_tab_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_selection_state_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_switch_state_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_text_changed, GUI.on_gui_event
    script.on_event defines.events.on_gui_value_changed, GUI.on_gui_event

return GUI
