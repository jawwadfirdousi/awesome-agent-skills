# SVG Templates

Use these as starting points. Replace IDs, titles, descriptions, dimensions, colors, and geometry for the actual request.

## Meaningful standalone SVG

Use for illustrations, diagrams, logos with semantic meaning, charts, and any SVG that should be understood by assistive technology.

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

Use for icons next to visible text, button icons with external labels, and purely decorative UI marks.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
  <path d="M5 12h14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M12 5l7 7-7 7" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

## Accessible UI icon

Use when the icon itself carries meaning and there is no surrounding visible label.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" role="img" aria-labelledby="download-title download-desc">
  <title id="download-title">Download</title>
  <desc id="download-desc">Arrow pointing down into a tray.</desc>
  <path d="M12 3v11" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M7 9l5 5 5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M5 19h14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
```

## Polished app-style illustration

Use for rich, self-contained vector artwork.

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
    <filter id="card-shadow" x="-20%" y="-20%" width="140%" height="140%">
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

Use for process flows and system diagrams.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 320" role="img" aria-labelledby="flow-title flow-desc">
  <title id="flow-title">Three step process</title>
  <desc id="flow-desc">Input flows to processing, then to output.</desc>
  <defs>
    <marker id="flow-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 Z" fill="#334155"/>
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

## Subtle animated SVG

Use only when animation is requested and the target allows SVG animation. Keep it optional and nonessential.

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

When animation is not essential, create a static equivalent instead.
