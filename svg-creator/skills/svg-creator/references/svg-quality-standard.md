# SVG Quality Standard

Use this reference for detailed SVG creation, especially when the user asks for a beautiful, polished, premium, brand-ready, production-ready, or error-free SVG.

## Quality target

A finished SVG should satisfy five checks:

1. It communicates the requested subject instantly.
2. It has a clear visual hierarchy: primary form, supporting details, and restrained accents.
3. It is technically valid XML with a correct SVG root, namespace, viewBox, references, and path data.
4. It is accessible or intentionally decorative.
5. It is safe and self-contained for browser rendering.

## Canvas and geometry defaults

Choose a coordinate system before drawing.

- UI icon: `viewBox="0 0 24 24"`; stroke width usually `1.5`, `1.75`, or `2`.
- Detailed app icon: `viewBox="0 0 64 64"`; combine filled shapes and consistent strokes.
- Illustration: `viewBox="0 0 512 512"`; use layered groups, gradients, and soft shadows.
- Wide hero illustration: `viewBox="0 0 1200 800"`; leave generous negative space.
- Diagram: use a grid-aligned canvas such as `0 0 800 500`; prioritize readable labels and connectors.
- Pattern: create one tile with clean repetition; document expected repeat behavior.

Keep all important geometry inside the viewBox. If a stroke reaches an edge, inset the shape by at least half the stroke width.

## Composition principles

- Use one dominant silhouette or focal area.
- Use 2 to 4 secondary detail clusters, not many unrelated details.
- Use repetition for polish: consistent radius, stroke width, spacing, and angles.
- Use asymmetry intentionally, not accidentally.
- Make small icons readable at 16 px and 24 px. Remove details that collapse at small size.
- For illustrations, add depth using overlap, scale, atmospheric contrast, gradients, and shadows rather than excessive outlines.

## Color strategy

Use a compact palette unless the user provides brand colors.

- Monochrome icons: `stroke="currentColor"` or `fill="currentColor"`.
- UI accent icon: one neutral plus one accent color.
- Rich illustration: 1 background color, 1 main hue, 1 secondary hue, 1 highlight, 1 shadow.
- Gradients should reinforce form or lighting. Do not use many unrelated gradients.
- Verify contrast for labels, thin strokes, and foreground objects.

Prefer defining reusable colors with CSS variables only when the target supports inline style customization. For portable standalone SVGs, direct `fill` and `stroke` attributes are safer.

## Strokes and joins

- Use one primary stroke width per icon family.
- Use `stroke-linecap="round"` and `stroke-linejoin="round"` for friendly UI icons, organic illustrations, and most line art.
- Use `stroke-linejoin="miter"` only for sharp technical or geometric styles.
- Use `vector-effect="non-scaling-stroke"` for diagrams that may be scaled non-uniformly.
- Avoid hairline strokes under `1` unit unless the viewBox and display size are known.

## Gradients, masks, clips, and filters

Use `<defs>` for reusable resources and keep IDs unique.

Good gradient practice:

```svg
<defs>
  <linearGradient id="example-gradient" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#8fd3ff"/>
    <stop offset="1" stop-color="#4c6fff"/>
  </linearGradient>
</defs>
```

Use masks and clips for clean shapes, highlights, and contained textures. Keep mask and clip geometry simple.

Use filters sparingly. For a shadow, prefer `feDropShadow` with a soft blur and low opacity. Expand the filter region to avoid clipping:

```svg
<filter id="card-shadow" x="-20%" y="-20%" width="140%" height="140%">
  <feDropShadow dx="0" dy="8" stdDeviation="10" flood-opacity="0.18"/>
</filter>
```

## Text

Use text only when the prompt requires it. SVG text can render differently across systems.

- For diagrams and charts, use common font families such as `system-ui`, `Arial`, or `sans-serif`.
- For logos and wordmarks, draw letters as paths when exact appearance matters, or state that text depends on the named font.
- Escape text content correctly.
- Keep text large enough for the intended display size.

## Icons

For icons:

- Prefer simple shapes and paths over detailed illustrations.
- Keep optical balance. Center the visual mass, not just the bounding box.
- Use even spacing and consistent corner radii.
- Test mentally at 16 px, 24 px, and 48 px.
- Do not include `<desc>` for purely decorative icons unless the user requests semantic output.

## Illustrations

For illustrations:

- Start with background or base shape, then main subject, then details, then highlights.
- Use groups with meaningful IDs: `background`, `subject`, `details`, `highlights`, `shadow`.
- Add depth through layered opacity and gradients.
- Keep filters limited and named.
- Avoid photo-like complexity. SVG excels at stylized vector art.

## Diagrams and charts

For diagrams and charts:

- Favor clarity over decoration.
- Align nodes, labels, and connectors to a grid.
- Use arrowheads with `<marker>` definitions.
- Use `role="img"` and provide a `<desc>` that summarizes the message.
- For data charts, ensure visual values match the provided data. If exact numeric plotting is needed, calculate coordinates before drawing.

## Logo-like output

For original logo concepts:

- Keep shapes distinctive at small sizes.
- Avoid imitating protected brand marks unless the user owns them or asks for analysis rather than reproduction.
- Use geometric primitives and negative space.
- Provide a clean monochrome version when practical.

## Production cleanup

Before finalizing:

- Remove unused defs.
- Remove comments unless they help editing.
- Remove hidden draft shapes.
- Ensure every `id` is referenced or intentionally available.
- Avoid excessive decimals. Two or three decimal places are usually enough.
- Run `scripts/validate_svg.py` in strict mode when possible.
