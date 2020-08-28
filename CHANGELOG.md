# Changelog

## 1.0.0 (2020-08-27)

### Changes

- Autosave timestamps are now 0-padded out to 5 digits for hours, 2 for minutes (e.g. SavePrefix-00012h00m), ensuring they sort lexicographically in chronological order

### Features

- The ability to manually trigger a timestamped save with a custom suffix, via a shortcut bar button or keybind

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
