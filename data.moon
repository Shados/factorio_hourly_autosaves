-- Create shortcut button for manual, named/tagged saves
data\extend {
  {
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
    associated_control_input: "tagged_save_hotkey"
  },
  {
    type: "custom-input"
    name: "tagged_save_hotkey"
    key_sequence: "SHIFT + F5"
  }
}
