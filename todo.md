# To-Do List

- [x] Do up a readme.md file for github
- [x] Make the missing-prefix reminder use a GUI dialog instead of a message
- [x] Make the missing-prefix GUI have a text box to actually *set* the prefix
  directly from the reminder :)
- [ ] Look at new/larger icon size and mipmap level stuff
- [ ] Figure out an *automated* testing approach that would actually work
- [ ] Requests for the Factorio devs
    - [ ] Add an additional `game.save()` function that works in SP and doesn't
      add the `autosave-` prefix?
- [ ] Multiple save-reminder prompt and manual-save GUIs can accumulate over
  time if each is not accepted or dismissed before the next is triggered. Each
  functions fully independently. It would probably be best to detect if an
  existing prompt is still around, and noop if so.
- [ ] Pause game while the manual save prompt is up.
- [ ] Look into replacing the prompt-mode GUI with some sort of
  notification/pop-up/toast approach instead, it's kinda intrusive as-is.

## Tooling

- [x] Move to Nix flakes
- [ ] Add a package output to the flake
- [ ] Set up a tag-triggered automated release process?
    - [ ] Release to GH
    - [ ] Release to Factorio mod portal
- [x] Write my own changelog generator, use a TOML file as the source rather
  than JSON?
    - Alternatively, just use yj to port TOML to JSON as part of the changelog
    build target?

## Unnecessary Optimisations

They may be the root of all evil, but they sure are fun to implement ;).

- [ ] Cache the settings from `settings.global` into our own table at the
  top-level in the control phase, then refresh it as required by hooking
  `on_runtime_mod_setting_changed`


## User Requests

### wrsomsky

1. ~~Drop the `autosave-` prefix~~
    - Not currently possible, the prefix comes from the `game.auto_save()`
    function used in SP games
2. [x] Fixed-width timestamps, left-padded with zeros
3. [x] Add an on-demand/tagged save function
    - [x] Takes a user-specified suffix to add to the save name
    - [x] GUI button for it
    - [x] Toggle option for enabling the GUI button
    - [x] Configurable keybind for it

### Mithaldu

1. [x] Add a "prompt only" configuration option to prompt the player for a
   tagged save instead of actually making the autosave
   - SP-only? If not, how do we determine who to prompt in MP? Make the setting
   `runtime-per-user` and prompt only the players that opt into it?
   - It turns out that mods can't trigger saves for non-server players, so this
   is irrelevant
