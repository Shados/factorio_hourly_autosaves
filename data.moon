-- Create shortcut button for manual, named/tagged saves
data.raw['shortcut'].tagged_save =
  type: "shortcut"
  name: "tagged_save"
  action: "lua"
  icon:
    filename: "__hourly_autosaves__/graphics/icons/shortcut-toolbar/mip/tagged_save-x32.png"
    size: 32
    scale: 0.5
    mipmap_count: 2
    flags: { "gui-icon" }
  toggleable: false
  -- associated_control_input: TODO
