---
name: home-assistant
description: Load when interacting with Home Assistant in any way.
---

# Home Assistant

Use `hass-cli`, which is already installed and authenticated. This is the Home Assistant ecosystem CLI, not the official Supervisor-focused `ha` CLI.

Preserve entity IDs and Home Assistant names verbatim unless explicitly asked otherwise.

Always use the canonical form `hass-cli -o json <command>`. The read-only permissions match this form so using another output option or omitting it interrupts autonomous work with an approval prompt.

Refer to Context7 library `/home-assistant-ecosystem/home-assistant-cli` when needed. Fall back to `hass-cli <command> --help` for the installed version.

## Common operations

Get one entity's current state:

```bash
hass-cli -o json state get light.kitchen
```

Find current states by entity ID regex:

```bash
hass-cli -o json state list '^sensor\.temperature'
```

Browse recent history for specific entities:

```bash
hass-cli -o json state history --since 2h sensor.temperature binary_sensor.motion
```

## Output

Filter at the source whenever possible. Unfiltered state, entity, and device lists can be excessively large.

Use `jq` to reduce the JSON further when needed:

```bash
hass-cli -o json state list '^sensor\.temperature' | jq 'map({entity_id, state, last_changed})'
```
