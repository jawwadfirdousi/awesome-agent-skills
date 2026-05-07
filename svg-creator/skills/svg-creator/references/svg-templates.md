# SVG Templates

Use these as starting points. Replace IDs, titles, descriptions, dimensions, colors, and geometry for the actual request.

## Meaningful standalone SVG

For illustrations, diagrams, logos with semantic meaning, charts, and any SVG that should be understood by assistive technology.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" role="img" aria-labelledby="example-title example-desc">
  <title id="example-title">Short descriptive title</title>
  <desc id="example-desc">One sentence describing the image and its purpose.</desc>
  <defs>
    <linearGradient id="example-gradient" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#8fd3ff"/>
      <stop offset="1" stop-color="#4c6fff"/>
    </linearGradient>
  </defs>
  <rect width="512" height="512" rx="96" fill="url(#example-gradient)"/>
</svg>
```

## Decorative UI icon

For icons next to visible text, button icons with external labels, and purely decorative UI marks.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
  <path d="M5 12h14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M12 5l7 7-7 7" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

## Accessible UI icon (atomic, conveys meaning)

When the icon itself carries meaning and there is no surrounding visible label.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" role="img" aria-labelledby="download-title download-desc">
  <title id="download-title">Download</title>
  <desc id="download-desc">Arrow pointing down into a tray.</desc>
  <path d="M12 3v11" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M7 9l5 5 5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M5 19h14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
```

## Graphics-symbol icon (for use in a sprite)

For atomic glyphs referenced by `<use>` from a sprite. The role identifies it as a meaningful symbol whose children are presentational (pruned from the AT tree).

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" role="graphics-symbol" aria-label="Search">
  <circle cx="11" cy="11" r="6" fill="none" stroke="currentColor" stroke-width="2"/>
  <path d="M16 16l4 4" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
```

## Sprite + use pattern

A sprite SVG and a referencing `<use>` site. `currentColor` and CSS variables pass through the `<use>` shadow DOM, which is the supported way to theme sprite icons from the host page.

```svg
<!-- sprite.svg -->
<svg xmlns="http://www.w3.org/2000/svg" style="display:none">
  <symbol id="heart" viewBox="0 0 24 24">
    <path d="M12 21s-7-4.35-7-10a4 4 0 017-2.65A4 4 0 0119 11c0 5.65-7 10-7 10z"
          fill="currentColor"/>
  </symbol>
</svg>

<!-- in the host page -->
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" style="color:#e11d48"
     role="img" aria-label="Favorite">
  <use href="sprite.svg#heart"/>
</svg>
```

## Polished app-style illustration

Rich, self-contained vector artwork. Note the explicit filter region (`-25% / 150%`) so the drop shadow isn't clipped.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" role="img" aria-labelledby="card-title card-desc">
  <title id="card-title">Abstract gradient card</title>
  <desc id="card-desc">Layered rounded cards with a soft gradient and shadow.</desc>
  <defs>
    <linearGradient id="card-bg" x1="96" y1="80" x2="416" y2="432" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#f7fbff"/>
      <stop offset="1" stop-color="#dfe8ff"/>
    </linearGradient>
    <linearGradient id="card-accent" x1="144" y1="128" x2="368" y2="352" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#7dd3fc"/>
      <stop offset="1" stop-color="#6366f1"/>
    </linearGradient>
    <filter id="card-shadow" x="-25%" y="-25%" width="150%" height="150%" color-interpolation-filters="sRGB">
      <feDropShadow dx="0" dy="18" stdDeviation="20" flood-opacity="0.18"/>
    </filter>
  </defs>
  <rect width="512" height="512" rx="112" fill="url(#card-bg)"/>
  <g filter="url(#card-shadow)">
    <rect x="116" y="128" width="280" height="256" rx="48" fill="#ffffff"/>
    <circle cx="204" cy="220" r="56" fill="url(#card-accent)"/>
    <path d="M160 320 C 206 270 244 270 292 320 C 316 346 342 354 372 336 L 372 384 L 160 384 Z" fill="#dbeafe"/>
    <path d="M196 220 C 196 198 214 180 236 180 C 258 180 276 198 276 220 C 276 242 258 260 236 260 C 214 260 196 242 196 220 Z" fill="#ffffff" opacity="0.36"/>
  </g>
</svg>
```

## Diagram with marker arrows

Process flows and system diagrams. Note `role="graphics-document"` because the layout itself conveys meaning.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 320" role="graphics-document" aria-labelledby="flow-title flow-desc">
  <title id="flow-title">Three step process</title>
  <desc id="flow-desc">Input flows to processing, then to output.</desc>
  <defs>
    <marker id="flow-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 Z" fill="context-stroke"/>
    </marker>
  </defs>
  <g fill="#f8fafc" stroke="#334155" stroke-width="2">
    <rect x="64" y="104" width="168" height="96" rx="18"/>
    <rect x="316" y="104" width="168" height="96" rx="18"/>
    <rect x="568" y="104" width="168" height="96" rx="18"/>
  </g>
  <g fill="none" stroke="#334155" stroke-width="3" marker-end="url(#flow-arrow)">
    <path d="M 232 152 H 300"/>
    <path d="M 484 152 H 552"/>
  </g>
  <g font-family="system-ui, sans-serif" font-size="22" font-weight="600" text-anchor="middle" fill="#0f172a">
    <text x="148" y="160">Input</text>
    <text x="400" y="160">Process</text>
    <text x="652" y="160">Output</text>
  </g>
</svg>
```

## Subtle SMIL animation

For animation that loops indefinitely. Always pair with a static fallback story when the consumer might prefer reduced motion.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120" role="img" aria-labelledby="pulse-title pulse-desc">
  <title id="pulse-title">Pulsing status dot</title>
  <desc id="pulse-desc">A status dot with a soft pulsing ring.</desc>
  <circle cx="60" cy="60" r="18" fill="#22c55e"/>
  <circle cx="60" cy="60" r="18" fill="none" stroke="#22c55e" stroke-width="6" opacity="0.45">
    <animate attributeName="r" values="18;42;18" dur="2s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0.45;0;0.45" dur="2s" repeatCount="indefinite"/>
  </circle>
</svg>
```

## CSS animation with prefers-reduced-motion guard

Preferred over SMIL for accessibility: CSS animations are paused automatically by browsers under `prefers-reduced-motion: reduce`. Add the explicit guard to short-circuit the animation entirely on those clients.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60" role="img" aria-label="Loading">
  <style>
    .spinner { transform-origin: 30px 30px; animation: spin 1s linear infinite; }
    @media (prefers-reduced-motion: reduce) {
      .spinner { animation: none; }
    }
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>
  <circle cx="30" cy="30" r="22" fill="none" stroke="#e2e8f0" stroke-width="6"/>
  <path class="spinner" d="M30 8 A22 22 0 0 1 52 30" fill="none" stroke="#3b82f6" stroke-width="6" stroke-linecap="round"/>
</svg>
```

## animateTransform: rotation

Rotation is an `<animateTransform>`, not `<animate>`. The `type` attribute is required.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" aria-hidden="true">
  <g transform="translate(50 50)">
    <rect x="-30" y="-30" width="60" height="60" rx="8" fill="#6366f1">
      <animateTransform attributeName="transform" type="rotate"
                        from="0" to="360" dur="3s" repeatCount="indefinite"/>
    </rect>
  </g>
</svg>
```

## animateMotion along a path

The only declarative way to follow an arbitrary path. CSS `offset-path` is similar but support varies.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 100" aria-hidden="true">
  <path id="wave" d="M 10 50 C 50 10, 90 90, 130 50 S 190 10, 198 50" fill="none" stroke="#cbd5e1" stroke-width="1"/>
  <circle r="6" fill="#3b82f6">
    <animateMotion dur="3s" repeatCount="indefinite" rotate="auto">
      <mpath href="#wave"/>
    </animateMotion>
  </circle>
</svg>
```

When animation is not essential, prefer a static equivalent.
