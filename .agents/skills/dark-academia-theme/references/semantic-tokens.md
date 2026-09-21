# Semantic tokens

## Canonical source

[`semantic-tokens.tokens.json`](semantic-tokens.tokens.json) is the canonical
color catalog. It uses the DTCG 2025.10 format and color modules. This guide
explains how to consume that source; it does not define a second value table.

Dotted semantic names are paths reconstructed from nested DTCG groups. A group
with a `$root` token exposes both the group's semantic path and more specific
children. For example, the root of a syntax family is the portable role while
its children are optional refinements. Curly-brace `$value` references are
aliases and must resolve to another color token without cycles.

## Fallbacks and adapters

Use each token's canonical `$value` when placement is unknown, when one
application key spans several surfaces, or when an adapter cannot verify the
rendered foreground and background pairing. An adapter may select a contextual
preference only when it exposes a distinct key for the exact surface named in
the token's
`org.dark-academia-theme.adapterPreferences.bySurface` extension. Extension
values use the same DTCG color-value shape as ordinary color tokens.

Unsupported syntax refinements fall back to the core role named in their token
description. Unsupported semantic aliases resolve through their canonical
`$value` reference. Adapters may collapse unsupported roles, but must not invent
new portable meanings or treat ANSI compatibility names as literal hue
requirements.

Application widget names, local theme keys, rendering channels, opacity,
textures, typography, and exact icon glyphs remain adapter or renderer concerns.
A low-contrast fill or border must not be the sole cue for an essential active,
selected, focus, or component state; add an independently sufficient label,
marker, underline, accent, or stronger outline.

## Contrast baseline

Terminal syntax foregrounds use WCAG 2.2
[SC 1.4.3 Contrast (Minimum)](https://www.w3.org/TR/WCAG22/#contrast-minimum)
AA ordinary-text contrast as the portable baseline. Every syntax foreground in
the canonical source reaches at least `4.5:1` against `surface.working`.
Foreground-to-foreground ratios describe tonal separation only and do not
replace text/background contrast testing.

The same `4.5:1` baseline applies to portable non-syntax text on every surface
where an adapter authorizes it. A palette does not by itself establish WCAG
conformance: adapters still own actual placement, font rendering, state cues,
and application behavior. Meaningful non-text component or state indicators
that rely on authored color must reach `3:1` against adjacent colors unless an
independently sufficient cue identifies them.

## Color conversion

[`../scripts/color-to-hsl.sh`](../scripts/color-to-hsl.sh) converts one exact
six-digit sRGB value to rounded integer HSL:

```sh
scripts/color-to-hsl.sh '#B89C5C'
```

The helper requires Bash and ImageMagick 7's `magick` executable on `PATH`. It
uses ImageMagick's HSL conversion and rounds hue, saturation, and lightness to
integers. It performs no network access and assumes a standard sRGB hex input.
