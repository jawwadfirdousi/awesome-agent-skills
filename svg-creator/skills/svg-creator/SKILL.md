---
name: svg-creator
description: create, edit, review, validate, and package high-quality svg graphics, icons, illustrations, diagrams, logos, charts, patterns, and inline svg code. use when the user asks to make a beautiful svg, generate an .svg file, fix or optimize svg markup, convert a visual concept into svg, design an icon system, or verify svg accessibility, safety, path data, viewbox, gradients, masks, filters, and browser-safe rendering.
---

# SVG Creator

Create SVGs that are visually polished, technically valid, accessible when meaningful, safe to render, and easy to edit.

## Core rules

- Default to a self-contained SVG. Do not use external images, external fonts, external CSS, scripts, event handlers, javascript URLs, data URLs, or `foreignObject` unless the user explicitly requires them and the target environment permits them.
- Always include `xmlns="http://www.w3.org/2000/svg"` and a valid `viewBox`.
- Prefer `viewBox="0 0 24 24"` for UI icons, `0 0 64 64` for detailed icons, and `0 0 512 512` or `0 0 1200 800` for illustrations, posters, diagrams, and hero art.
- For meaningful graphics, set `role="img"`, add `aria-labelledby`, and place `<title>` then `<desc>` as the first children.
- For decorative icons, set `aria-hidden="true"` and `focusable="false"`; do not add visible semantic labels unless asked.
- Use stable, unique IDs prefixed with the subject, for example `mountain-gradient-a`, `rocket-shadow`, or `chart-clip`.
- Use `currentColor` for monochrome UI icons unless the user requests a fixed palette.
- Keep geometry inside the viewBox. Account for stroke width so edges are not clipped.
- Use simple vector primitives where possible. Use paths for organic shapes, icons, curves, and custom silhouettes.
- Prefer a small number of coordinated colors, consistent stroke widths, round linecaps where appropriate, and moderate gradients or shadows.

## Workflow

1. Identify the output type: icon, logo, illustration, diagram, chart, badge, pattern, or markup repair.
2. Resolve missing details with sensible defaults instead of asking, unless the user requires a brand-specific asset, exact dimensions, or a legally sensitive logo recreation.
3. Create a short design plan before writing complex SVGs: canvas, subject, visual hierarchy, palette, accessibility mode, and validation target.
4. Write the SVG as clean, standalone markup. Use indentation and grouping names that make later edits easy.
5. Validate before finalizing whenever code execution is available:

```bash
python scripts/validate_svg.py output.svg --strict
```

6. If validation fails, fix the reported errors and rerun the validator until it passes.
7. If code execution is unavailable, manually apply `references/svg-validation-checklist.md` before presenting the SVG.
8. When returning a file, include the `.svg` artifact. When returning inline code, provide the complete SVG element only, unless the user asks for HTML integration.

## Reference loading

- Read `references/svg-quality-standard.md` before creating detailed illustrations, logos, diagrams, patterns, or anything where aesthetics matter.
- Read `references/svg-templates.md` when the user needs a specific SVG type or when starting from a blank prompt.
- Read `references/svg-path-guide.md` before writing or repairing complex `d` path data.
- Read `references/svg-validation-checklist.md` when validation is not available or when reviewing existing SVG markup.

## Output contract

For a new SVG, produce one of these outputs:

- Complete standalone `.svg` file with valid XML and no missing referenced IDs.
- Complete inline `<svg>` element suitable for HTML.
- A concise explanation of design choices plus the SVG, only when the user asks for explanation or the design is complex.

For SVG repair, return the corrected complete SVG, not a patch.

For multiple SVGs, use a consistent coordinate system, stroke language, ID prefix, and color strategy across the set.

## Gotchas

- `viewBox` is case-sensitive. `viewbox` is invalid.
- Any `url(#id)` reference must point to an existing ID.
- Arc path commands need exactly seven values per segment: `rx ry x-axis-rotation large-arc-flag sweep-flag x y`.
- `large-arc-flag` and `sweep-flag` must be `0` or `1`.
- XML requires escaped text: use `&amp;`, `&lt;`, and `&gt;` in text nodes and attributes when needed.
- Duplicate IDs can break gradients, masks, filters, clipping paths, markers, and ARIA labels.
- Filters can be clipped if their region is too small. Set explicit `x`, `y`, `width`, and `height` when using shadows or glows.
- Text rendering varies by system font. For exact logos or wordmarks, use geometric paths or state the font dependency clearly.
- Browser support and host sanitizer rules vary. For safest output, avoid SMIL, CSS imports, embedded raster data, and nonstandard attributes unless the target is known.
