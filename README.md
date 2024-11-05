# <img src="thumbnail.png" alt="Mod thumbnail/icon" /> Hourly Autosaves

A tiny Factorio mod to create timestamped saves with a custom prefix at a
configurable interval (by default, hourly).

I created the mod because I wanted to retain a series of saves created at
regular intervals, allowing me to see how my factory evolves over time using
tools like [this](https://github.com/L0laapk3/FactorioMaps).

## Features

- Saves are timestamped with the gameplay time using 5+2-digit hour+minute
  0-padded timestamps (e.g. `00012h05m`), which ensures that the lexicographic
  order of the save names is equivalent to their chronological order (read:
  sorting the saves by name *also* sorts them by playtime)
- Saves are named with a custom prefix that can be specified per-game, and the
  mod will remind you if it is unset at the start of a new map
- Timestamped saves can be manually triggered via a shortcut bar button or a
  keybind, with a user-supplied suffix added to their name (note: can only be
  done by admins in multiplayer, as the saves are made on the server-side)
- Save interval is configurable, and can be changed on-the-fly in a running
  game


## Contributing

If you want to directly comment on the code, or make a pull request, do so
through GitHub. Otherwise, please use the [mod discussion
board](https://mods.factorio.com/mod/hourly_autosaves/discussion) on the
Factorio mod portal.
