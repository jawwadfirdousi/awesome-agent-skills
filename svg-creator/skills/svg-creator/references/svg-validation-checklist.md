# SVG Validation Checklist

Use this checklist when reviewing SVG output manually or when `scripts/validate_svg.py` cannot be executed.

## XML and SVG root

- The SVG is complete XML or a complete inline `<svg>` element.
- The root element is `<svg>`.
- The root has `xmlns="http://www.w3.org/2000/svg"`.
- The root has a correctly cased `viewBox` with four finite numbers.
- The viewBox width and height are positive.
- XML special characters in text and attributes are escaped.
- Tags are properly closed.

## Accessibility

For meaningful SVGs:

- Root has `role="img"`.
- Root has `aria-labelledby` pointing to existing IDs.
- `<title>` is present and descriptive.
- `<desc>` is present for diagrams, charts, illustrations, and non-obvious graphics.
- `<title>` and `<desc>` appear before drawing elements.

For decorative SVGs:

- Root has `aria-hidden="true"`.
- Root has `focusable="false"`.
- No redundant visible or semantic label is needed.

## Safety

- No `<script>` elements.
- No event handler attributes such as `onclick`, `onload`, or `onmouseover`.
- No `javascript:` URLs.
- No external image, font, CSS, or link references.
- No `data:` URLs unless explicitly required and allowed.
- No `foreignObject` unless explicitly required and allowed.
- No `@import` in styles.
- No XML doctype or entity declarations.

## References

- Every `url(#id)` reference points to an existing ID.
- Every `href="#id"` or `xlink:href="#id"` points to an existing ID.
- Every ARIA ID reference exists.
- IDs are unique.
- IDs are stable and readable.
- Gradients, masks, clips, filters, markers, patterns, and symbols have unique IDs.

## Geometry and rendering

- Main shapes are inside the viewBox.
- Strokes near edges are inset enough to avoid clipping.
- Filled shapes have intended closure.
- Transparent shapes are intentional.
- Filter regions are large enough for shadows and glows.
- Gradients use the intended coordinate mode.
- Text is readable at the target size.
- Icons remain legible at small sizes.

## Path data

- Every path starts with `M` or `m`.
- Every command has the correct number of numeric values.
- Arc commands have seven values per segment.
- Arc flags are `0` or `1`.
- Closed paths use `Z` only when closure is intended.
- No path contains invalid characters, unbalanced signs, or missing values.

## Aesthetic quality

- The SVG has one clear focal point.
- Color palette is coherent and restrained.
- Stroke widths, corner radii, and spacing are consistent.
- Gradients and shadows are subtle and purposeful.
- Detail level matches the intended display size.
- Groups and IDs make the file understandable for future edits.

## Final step

If tools are available, save the SVG and run:

```bash
python scripts/validate_svg.py output.svg --strict
```

Fix every error. For production work, fix warnings too unless the warning is intentionally accepted for the target environment.
