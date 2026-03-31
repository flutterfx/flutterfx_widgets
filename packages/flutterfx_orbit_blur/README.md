# FlutterFX Orbit Blur

[![pub package](https://img.shields.io/pub/v/flutterfx_orbit_blur.svg)](https://pub.dev/packages/flutterfx_orbit_blur)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue.svg)](https://flutter.dev)

A Flutter widget that renders two orbiting icon rings with a frosted-glass blur circle at the center. Part of the [FlutterFX](https://flutterfx.com) collection.

![Orbit Blur Demo](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExdTM0NmE1bXdrZWNhOTZ2NjNqaWx4dmJnenMyaTE1dWoyZWFwdzFyZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/rP0BIoI1OfqyKZMvax/giphy.gif)

## Features

- 🪐 Two counter-rotating orbit rings with staggered animations
- 🔵 Frosted-glass `BackdropFilter` blur center — blur level, size and tint all customizable
- 🎨 `OrbitStyle` — one object controls every visual: colors, blur, icon size, center widget
- 🖼️ Pass **any widget** as orbit items or as the center logo
- 🌗 Built-in `OrbitStyle.dark()` and `OrbitStyle.light()` presets
- 🧩 Composable — use `OrbitingCircle` or `SingleOrbitingCircle` standalone
- ⚡ Zero external dependencies — only Flutter
- 📱 Works on all platforms (iOS, Android, Web, Desktop)

## Installation

```bash
flutter pub add flutterfx_orbit_blur
```

Or add to your `pubspec.yaml`:
```yaml
dependencies:
  flutterfx_orbit_blur: ^1.0.0
```

---

## Usage

### Zero-config (works out of the box)

```dart
import 'package:flutterfx_orbit_blur/flutterfx_orbit_blur.dart';

OrbitingIcons()
```

---

### Dark / light presets

```dart
// Dark background (default)
OrbitingIcons(style: OrbitStyle.dark())

// Light background
OrbitingIcons(style: OrbitStyle.light())
```

---

### Custom icon colors & blur

```dart
OrbitingIcons(
  style: OrbitStyle(
    iconColor: Colors.amber,
    iconContainerColor: Colors.amber.withValues(alpha: 0.15),
    iconContainerBorderColor: Colors.amber.withValues(alpha: 0.4),
    orbitPathColor: Colors.amber.withValues(alpha: 0.15),
    centerBlurSigma: 10,           // how blurry the center glass is
    centerColor: Colors.amber.withValues(alpha: 0.2),
  ),
  leftIcons: [Icons.bolt, Icons.star, Icons.local_fire_department],
  rightIcons: [Icons.sunny, Icons.flash_on, Icons.auto_awesome],
)
```

---

### Custom center widget (logo, icon, image, anything)

Replace the default chevron with any widget via `OrbitStyle.centerWidget`:

```dart
OrbitingIcons(
  style: OrbitStyle(
    centerWidget: Icon(Icons.rocket_launch, color: Colors.purpleAccent, size: 26),
    centerBlurSigma: 12,
    centerColor: Colors.purpleAccent.withValues(alpha: 0.2),
  ),
)
```

Use your own logo:
```dart
OrbitingIcons(
  style: OrbitStyle(
    centerSize: 80,
    centerWidget: Image.asset('assets/logo.png', width: 36, height: 36),
  ),
)
```

---

### Custom widgets on the orbit rings

Pass any widget list directly — no icon container is added:

```dart
OrbitingIcons(
  leftWidgets: [
    CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
    FlutterLogo(size: 24),
    Icon(Icons.star, color: Colors.yellow),
  ],
  rightWidgets: [
    Text('🚀', style: TextStyle(fontSize: 20)),
    Text('⭐', style: TextStyle(fontSize: 20)),
    Text('🔥', style: TextStyle(fontSize: 20)),
  ],
)
```

> `leftWidgets` / `rightWidgets` take priority over `leftIcons` / `rightIcons`.

---

### Quick tweak with `copyWith`

Start from a preset and only override what you need:

```dart
OrbitingIcons(
  style: OrbitStyle.dark().copyWith(
    iconColor: Colors.teal,
    centerBlurSigma: 15,
    centerWidget: Icon(Icons.hub, color: Colors.teal),
  ),
)
```

---

### Reactive config at runtime

`OrbitConfig` is a `ChangeNotifier` — mutating any property triggers a rebuild:

```dart
final config = OrbitConfig(reverse: false, duration: 6.0);

AnimatedBuilder(
  animation: config,
  builder: (context, _) => OrbitingIcons(
    reverse: config.reverse,
    duration: config.duration,
    showPaths: config.showPaths,
  ),
)

// Change from anywhere — widget rebuilds automatically:
config.duration = 4.0;
config.reverse = !config.reverse;
```

---

## API Reference

### `OrbitingIcons`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `style` | `OrbitStyle` | `OrbitStyle.dark()` | All visual settings |
| `reverse` | `bool` | `true` | `true` → left counter-clockwise, right clockwise |
| `duration` | `double` | `10.0` | Seconds per full orbit |
| `showPaths` | `bool` | `true` | Show faint circular guide lines |
| `leftIcons` | `List<IconData>?` | 3 defaults | Icons for the left ring (auto-wrapped) |
| `rightIcons` | `List<IconData>?` | 3 defaults | Icons for the right ring (auto-wrapped) |
| `leftWidgets` | `List<Widget>?` | `null` | Custom widgets for the left ring |
| `rightWidgets` | `List<Widget>?` | `null` | Custom widgets for the right ring |

---

### `OrbitStyle`

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `iconColor` | `Color` | `Colors.blue` | Icon color inside auto-generated containers |
| `iconContainerColor` | `Color` | dark grey | Background of the icon circle |
| `iconContainerBorderColor` | `Color` | mid grey | Border of the icon circle |
| `iconSize` | `double` | `20` | Icon size in logical pixels |
| `orbitPathColor` | `Color` | white 10% | Color of the orbit guide lines |
| `centerSize` | `double` | `70` | Diameter of the frosted-glass circle |
| `centerBlurSigma` | `double` | `5` | Blur intensity of the center backdrop |
| `centerColor` | `Color` | grey 15% | Tint of the frosted-glass circle |
| `centerWidget` | `Widget?` | `null` | Widget inside the center (replaces chevron) |

**Named constructors:** `OrbitStyle.dark()` · `OrbitStyle.light()`  
**Utility:** `OrbitStyle.copyWith({...})`

---

### `OrbitConfig` (reactive)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `reverse` | `bool` | `true` | Orbit direction |
| `duration` | `double` | `10.0` | Seconds per orbit |
| `showPaths` | `bool` | `true` | Guide line visibility |

---

## How It Works

Each orbit item is driven by its own `AnimationController`. Position is
calculated every frame with:

```
x = centerX + radius × cos(angle)
y = centerY + radius × sin(angle)
```

Items in the same ring are staggered by `duration / count` seconds so they
spread evenly around the ring on startup without bunching.

The center circle uses `BackdropFilter(ImageFilter.blur(...))` clipped to an
oval, creating the frosted-glass effect over whatever is drawn behind it.

---

## More FlutterFX Widgets

- [flutterfx_blur_fade](https://pub.dev/packages/flutterfx_blur_fade) — Blur and fade entrance animation
- [flutterfx_folder](https://pub.dev/packages/flutterfx_folder) — 3-D folder open/close animation
- View all at [flutterfx.com](https://flutterfx.com)

## Contributing

Found a bug? Have a suggestion? Open a PR at the
[FlutterFX repository](https://github.com/flutterfx/flutterfx_widgets).

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [Amal Chandran](https://x.com/aml_chandran) | [FlutterFX](https://flutterfx.com)
