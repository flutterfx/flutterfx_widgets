## 1.1.0

- Added `OrbitStyle` — single config object for all visual customization
- `OrbitStyle.dark()` and `OrbitStyle.light()` named preset constructors
- `OrbitStyle.copyWith()` for incremental overrides
- `centerWidget` — pass any widget as the center logo (replaces default chevron)
- `centerBlurSigma`, `centerSize`, `centerColor` — full frosted-glass control
- `leftWidgets` / `rightWidgets` — pass any widget list to orbit rings
- `iconContainerColor`, `iconContainerBorderColor`, `iconSize` — full icon container theming
- `orbitPathColor` — control the orbit guide line color
- ChevronPainter color now follows `OrbitStyle.iconColor`

## 1.0.0

- Initial release
- OrbitingIcons with two orbiting rings and a frosted-glass blur center
- OrbitingCircle and SingleOrbitingCircle for custom compositions
- OrbitConfig ChangeNotifier for reactive external control
- Zero external dependencies
