---
name: esphome
description: Load when interacting with ESPHome in any way.
---

# ESPHome

`aioesphomeapi-discover-once` and `aioesphomeapi-logs` are installed.

`aioesphomeapi-discover` runs indefinitely. Discover local devices with the bounded wrapper:

```bash
aioesphomeapi-discover-once
```

Stream device logs and entity state changes:

```bash
script -q /dev/null aioesphomeapi-logs <address> | head -n 200
```

Logs stream indefinitely. Run them through `script` so output is flushed, bound the output, and set a short Bash tool timeout. Treat the timeout as expected.

If the device requires encryption, ask the user for its Noise PSK and add `--noise-psk <key>` before `<address>`.

For targeted diagnostics, replace `head -n 200` with `rg --line-buffered '<pattern>' | head -n 20`. Use the smallest useful output limit.
