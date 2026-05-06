# SVG Path Guide

Use this reference before creating or repairing complex `d` attributes.

## Commands

Path commands are case-sensitive. Uppercase commands use absolute coordinates. Lowercase commands use coordinates relative to the current point.

| Command | Values | Meaning |
| --- | --- | --- |
| `M` / `m` | `x y` | Move to point |
| `L` / `l` | `x y` | Line to point |
| `H` / `h` | `x` | Horizontal line |
| `V` / `v` | `y` | Vertical line |
| `C` / `c` | `x1 y1 x2 y2 x y` | Cubic Bezier curve |
| `S` / `s` | `x2 y2 x y` | Smooth cubic curve |
| `Q` / `q` | `x1 y1 x y` | Quadratic Bezier curve |
| `T` / `t` | `x y` | Smooth quadratic curve |
| `A` / `a` | `rx ry rot large sweep x y` | Elliptical arc |
| `Z` / `z` | none | Close path |

## Required patterns

- Start every visible path with `M` or `m`.
- Use `Z` only when the shape should be closed.
- After an initial `M x y`, extra coordinate pairs are treated as implicit `L` commands.
- Arc flags must be exactly `0` or `1`.
- Avoid combining unrelated shapes into one unreadable path unless optimization is the goal.
- For editable illustrations, prefer several named paths over one giant path.

## Arc command reminder

Arc syntax:

```svg
d="M 12 4 A 8 8 0 1 1 11.99 4"
```

The seven values after `A` are:

1. `rx`: x radius
2. `ry`: y radius
3. `rot`: x-axis rotation in degrees
4. `large`: large-arc flag, `0` or `1`
5. `sweep`: sweep flag, `0` or `1`
6. `x`: destination x
7. `y`: destination y

Common arc mistakes:

- Supplying six or eight values instead of seven.
- Using `true` or `false` for flags.
- Using negative radii. SVG may normalize them, but explicit positive radii are clearer.
- Forgetting that arcs draw from the current point to the destination point.

## Curve practice

For smooth icons and illustrations:

- Use cubic curves for organic shapes and expressive silhouettes.
- Use quadratic curves for simpler rounded forms.
- Keep control points close enough to avoid loops unless a loop is intentional.
- Use consistent handle lengths for symmetrical forms.
- For mirrored forms, calculate mirrored coordinates rather than estimating.

## Separators and numbers

SVG allows compact path syntax, but readable paths reduce errors. Prefer spaces between values:

```svg
d="M 4 12 C 4 7.6 7.6 4 12 4 S 20 7.6 20 12 16.4 20 12 20 4 16.4 4 12 Z"
```

Avoid overly compressed syntax unless optimizing after validation.

## Repair strategy

When a path fails validation:

1. Tokenize it mentally into commands and numbers.
2. Verify each command has the required number of values.
3. Check arc flags.
4. Check that the path begins with `M` or `m`.
5. Split long paths into separate paths if the error is hard to locate.
6. Re-run `scripts/validate_svg.py`.
