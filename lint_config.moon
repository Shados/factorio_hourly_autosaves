{
  whitelist_globals: {
    -- Whitelist for all files
    ["."]: {
      -- Factorio global data prototype access
      'data',
      -- Factorio global classes
      'commands', 'game', 'rcon', 'remote', 'rendering', 'script', 'settings',
      -- Factorio global objects
      'defines', 'global',
      -- Factorio global libraries
      'serpent',
      -- Factorio global functions
      'localised_print', 'log', 'table_size',
    },
  }
}
