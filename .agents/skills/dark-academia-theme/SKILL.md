---
name: dark-academia-theme
description: Apply the Dark Academia palette through semantic tokens, portable fallbacks, adapter preferences, terminal syntax guidance, or exact color-to-HSL conversion.
license: MIT
compatibility: The color-to-HSL helper requires Bash and ImageMagick 7 magick.
---

# Dark Academia Theme

Use semantic roles rather than application-specific theme keys. Preserve the
canonical role meaning when an adapter maps a token to a foreground,
background, border, fill, marker, or compatibility slot.

## Color notation

Present colors directly to users as programmatically rounded integer HSL. Use
hex in user-facing output only when hex notation is materially under discussion.
Durable source data may preserve exact hex.

## Routes

- **Semantic tokens** → [Token model and adapter guidance](references/semantic-tokens.md).
- **Canonical source** → [DTCG 2025.10 tokens](references/semantic-tokens.tokens.json).
- **HSL conversion** → [`color-to-hsl.sh`](scripts/color-to-hsl.sh).
  Run it with one `RRGGBB` or `#RRGGBB` argument.

## Glossary

**Semantic token**:
A purpose-based color role whose meaning stays stable while adapters map it to
application-specific theme keys and rendering channels.
_Avoid_: Naming a token after one application's widget or configuration key
