data\extend {
  {
    name: "hourly_autosaves_debug"
    type: "bool-setting"
    default_value: false
    setting_type: "runtime-global"
    order: "0000"
    hidden: true
  },
  {
    name: "hourly_autosaves_interval"
    type: "int-setting"
    default_value: 60
    minimum_value: 1
    setting_type: "runtime-global"
    order: "0100"
  },
  {
    name: "hourly_autosaves_prefix"
    type: "string-setting"
    default_value: ""
    setting_type: "runtime-global"
    order: "0200"
    allow_blank: true
  },
}

return
