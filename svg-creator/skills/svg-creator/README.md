# svg-creator

Creates, edits, validates, and packages high-quality SVGs: icons, logos, illustrations, diagrams, charts, patterns, and inline SVG code.

## When it triggers

Auto-invokes on prompts like *"make me an SVG of …"*, *"design a 24×24 icon for …"*, *"give me a logo"*, *"create a diagram showing …"*, or *"fix this SVG markup"*. Or invoke explicitly:

```text
/svg-creator:svg-creator   # Claude Code
$svg-creator               # Codex
```

## What it does

1. Identifies the output type (icon, logo, illustration, diagram, chart, pattern, or markup repair).
2. Picks sensible defaults for `viewBox`, palette, and accessibility mode rather than asking when it doesn't have to.
3. Writes clean, standalone SVG markup with valid XML, stable ID prefixes, and proper accessibility (`role="img"` + `<title>`/`<desc>` for meaningful graphics, `aria-hidden` for decorative ones).
4. Validates with the bundled `scripts/validate_svg.py` when code execution is available; falls back to the manual checklist in `references/svg-validation-checklist.md` otherwise.
5. Returns either a complete `.svg` file or a complete inline `<svg>` element, depending on the request.

## Example prompts

A reusable template you can fill in:

```
Create a [static or animated] SVG [icon or illustration] of [subject].

Style: [modern, minimal, playful, elegant, polished].
Composition: [pose, layout, key elements].
Color: [palette].
Shape: [smooth curves, geometric, bold silhouette, simple details].
Animation: [only if animated: pulse, float, rotate, shimmer, wave, bounce].
Motion: [slow, subtle, smooth, seamless loop].
```

A few worked examples:

**Search icon (static, UI)**

```
Create a clean search icon.

Style: modern UI icon, simple and professional.
Composition: circular lens with angled handle.
Color: single-color.
Shape: consistent line weight, balanced spacing, crisp geometry.
```

**Dolphin icon (static, organic)**

```
Create a beautiful blue dolphin icon.

Style: modern, smooth, minimal, friendly, and polished.
Composition: dolphin in a graceful jumping pose, centered, strong silhouette, readable at small sizes.
Color: ocean blue with optional aqua highlight.
Shape: smooth curves, simple fins, elegant tail, no tiny details.
```

**Spinning loader (animated, UI)**

```
Create a clean animated loading spinner.

Style: modern, minimal, professional UI icon.
Composition: circular spinner with one emphasized segment.
Animation: smooth continuous rotation.
Motion: steady, seamless, lightweight.
Color: single-color.
```

**Heartbeat icon (animated, decorative)**

```
Create a simple animated heart icon.

Style: smooth, modern, friendly, polished.
Composition: centered heart.
Animation: make the heart gently beat with a subtle scale pulse.
Motion: soft, rhythmic, smooth loop.
Color: warm red or pink.
```

## Bundled resources

| Path | Purpose |
| --- | --- |
| `scripts/validate_svg.py` | Strict SVG validator — XML well-formedness, ID resolution, path-data sanity, viewBox, safety checks |
| `references/svg-quality-standard.md` | Aesthetic and structural quality bar (used for detailed illustrations, logos, diagrams) |
| `references/svg-templates.md` | Starter templates by SVG type — including sprite + `<use>`, CSS animation with `prefers-reduced-motion`, `animateTransform`, `animateMotion` |
| `references/svg-path-guide.md` | Path data BNF, smooth-curve reflection rules, implicit lineto, arc parsing |
| `references/svg-security.md` | W3C / OWASP / DOMPurify-grounded security deny list (XSS surfaces, XXE, SMIL hijack) |
| `references/svg-validation-checklist.md` | Manual checklist when the validator script can't run |
| `agents/openai.yaml` | Codex agent metadata (display name, default prompt, etc.) |

The skill loads each reference on demand — they don't add to context until needed.

## Won't do

- No `<script>` tags, event handlers, `javascript:` URLs, external CSS, external fonts, embedded raster data, or `foreignObject` unless you explicitly ask and the target environment supports it.
- No SMIL or nonstandard attributes by default — output is meant to render safely across browsers and host sanitizers.

## Install / uninstall

See the [top-level README](../../../README.md).
