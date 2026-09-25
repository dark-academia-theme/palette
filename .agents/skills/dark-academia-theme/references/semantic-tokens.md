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

When an adapter cannot express a more specific role, use these approved
fallback edges. These are adapter-collapse rules, not replacements for the
canonical values or aliases in the DTCG source:

```text
surface.secondary -> surface.working
surface.raised -> surface.secondary
surface.active -> surface.raised
surface.organizational -> surface.secondary
surface.organizational.raised -> surface.organizational
surface.organizational.active -> surface.organizational.raised
surface.rail -> surface.working
surface.control -> surface.working

content.secondary -> content.primary
content.muted -> content.secondary
content.status -> content.secondary
content.inverse -> content.primary
content.label -> content.primary
content.navigation -> content.primary
content.marker -> content.secondary
content.symbol -> content.secondary

state.diff.added -> state.success
state.diff.changed -> state.warning
state.diff.removed -> state.error
state.permission.read -> content.secondary
state.permission.write -> content.secondary
state.permission.execute -> content.secondary
state.permission.missing -> content.muted

interaction.search.current -> interaction.search.match
interaction.key -> interaction.action.marked
interaction.cursor -> content.primary

border.window.active -> border.window.inactive
border.component -> border.window.inactive
border.component.active -> border.component

syntax.character -> syntax.string
syntax.float -> syntax.number
syntax.boolean -> syntax.constant
syntax.schema -> syntax.type
syntax.keyword.declaration -> syntax.keyword
syntax.keyword.control -> syntax.keyword
syntax.directive -> syntax.keyword
syntax.variable.builtin -> syntax.variable
syntax.parameter -> syntax.variable
syntax.property -> syntax.variable
syntax.field -> syntax.property
syntax.function.builtin -> syntax.function
syntax.function.call -> syntax.function
syntax.method -> syntax.function
syntax.constructor -> syntax.type
syntax.type.builtin -> syntax.type
syntax.type.qualifier -> syntax.type
syntax.attribute -> syntax.type
syntax.namespace -> syntax.type
syntax.constant.builtin -> syntax.constant
syntax.string.escape -> syntax.string
syntax.string.regex -> syntax.string
syntax.tag -> syntax.property
syntax.tag.attribute -> syntax.attribute
syntax.tag.delimiter -> syntax.punctuation
```

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

[`../scripts/hex-to-hsl.sh`](../scripts/hex-to-hsl.sh) converts one exact
six-digit sRGB value to rounded integer HSL:

```sh
scripts/hex-to-hsl.sh '#B89C5C'
```

The helper requires Bash and ImageMagick 7's `magick` executable on `PATH`. It
treats the input as CSS hexadecimal notation for sRGB and emits its CSS HSL
representation. It rounds nonnegative hue, saturation, and lightness values to
the nearest integer with half values rounded upward, normalizes hue to
`[0, 360)`, and emits hue `0` for achromatic colors. It performs no network
access.
