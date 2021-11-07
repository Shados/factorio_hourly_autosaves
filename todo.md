# To-Do List

- [x] Do up a readme.md file for github
- [x] Make the missing-prefix reminder use a GUI dialog instead of a message
- [ ] Requests for the Factorio devs
    - [ ] Add an additional `game.save()` function that works in SP and doesn't
      add the `autosave-` prefix
    - [ ] Allow creating saves in subdirectories from the various save
      functions -- this can only be done manually, right now
- [ ] Make the missing-prefix GUI have a text box to actually *set* the prefix
  directly from the reminder :)


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

1. [ ] Add a "prompt only" configuration option to prompt the player for a
   tagged save instead of actually making the autosave
   - SP-only? If not, how do we determine who to prompt in MP? Make the setting
   `runtime-per-user` and prompt only the players that opt into it?
