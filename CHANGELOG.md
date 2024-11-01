# Changelog

## 1.1.0 (2024-11-01)

### Changes

- The missing-prefix reminder now prompts the player to set the setting directly from its GUI

### Features

- A 'prompt-only' mode, where it won't make the autosave directly but instead prompt the user to make a save manually at the configured interval

### Other

- Wrote my own changelog generation utility to replace the Python-based one I was using previously

---

## 1.0.1 (2021-02-23)

### Other

- Marked as compatible with Factorio 1.1

---

## 1.0.0 (2020-08-27)

### Changes

- Autosave timestamps are now 0-padded out to 5 digits for hours, 2 for minutes (e.g. SavePrefix-00012h00m), ensuring they sort lexicographically in chronological order
- The missing-prefix reminder now uses a GUI dialog instead of a simple text message

### Features

- The ability to manually trigger a timestamped save with a custom suffix, via a shortcut bar button or keybind

### Other

- Gave the mod a thumbnail/icon

---

## 0.0.3 (2020-07-24)

### Changes

- Made the autosave interval configurable (per map, in minutes, defaulting to 60)

---

## 0.0.2 (2020-07-21)

### Other

- Fixed packaging process to include a copy of the license in the final zip

---

## 0.0.1 (2020-07-19)

### Features

- Automatically saves after every hour of gameplay to a timestamped save, with a configurable prefix
- The game will prompt the player if the autosave prefix is not configured
