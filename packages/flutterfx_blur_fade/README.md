# BlurFade

[![pub package](https://img.shields.io/pub/v/flutterfx_blur_fade.svg)](https://pub.dev/packages/flutterfx_blur_fade)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue.svg)](https://flutter.dev)

A Flutter widget that animates children with a smooth combined blur and fade effect. Part of the [FlutterFX](https://flutterfx.com) collection.

![BlurFade Demo](https://github.com/flutterfx/flutterfx_widgets/blob/main/external_asset/showcase_blurfade.gif?raw=true)

## Features

- 🎬 Smooth blur-to-sharp transition combined with fade-in
- ⚡ Zero external dependencies - just Flutter
- 🎛️ Customizable duration and delay
- 🔄 Controllable visibility with reversible animations
- 📱 Works on all platforms (iOS, Android, Web, Desktop)

## Installation
```bash
flutter pub add flutterfx_blur_fade
```

Or add to your `pubspec.yaml`:
```yaml
dependencies:
  flutterfx_blur_fade: ^1.0.0
```

## Usage

### Basic Usage
```dart
import 'package:flutterfx_blur_fade/flutterfx_blur_fade.dart';

BlurFade(
  child: Text('Hello World'),
)
```

### With Customization
```dart
BlurFade(
  duration: Duration(milliseconds: 400),
  delay: Duration(milliseconds: 200),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Animated Content'),
  ),
)
```

### Controlled Visibility

You can programmatically control the animation direction using the `isVisible` parameter:
```dart
BlurFade(
  isVisible: _showContent, // true to animate in, false to animate out
  duration: Duration(milliseconds: 300),
  child: Text('Toggle me!'),
)
```

### Staggered List Animation
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return BlurFade(
      delay: Duration(milliseconds: 100 * index),
      child: ListTile(
        title: Text(items[index]),
      ),
    );
  },
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget` | **required** | The widget to animate |
| `duration` | `Duration` | `200ms` | Animation duration |
| `delay` | `Duration` | `0ms` | Delay before animation starts |
| `isVisible` | `bool?` | `null` | Controls animation direction. `true` animates in, `false` animates out, `null` auto-plays on first build |

## How It Works

The animation uses two overlapping phases with `Curves.easeOut`:

1. **Opacity** (0% - 60% of duration): Fades the widget from 0 to 1
2. **Blur** (40% - 100% of duration): Transitions blur sigma from 10 to 0

This overlap creates a seamless, polished effect where the content becomes visible while simultaneously sharpening into focus.

### Visibility Behavior

- When `isVisible` is `null` (default): Animation plays forward automatically on first build
- When `isVisible` is `true`: Animation plays forward
- When `isVisible` is `false`: Animation reverses (fades out with blur)

## More FlutterFX Widgets

Check out other widgets in the FlutterFX collection:
- [flutterfx_meteors](https://pub.dev/packages/flutterfx_meteors) - Animated meteor shower effect
- [flutterfx_border_beam](https://pub.dev/packages/flutterfx_border_beam) - Animated border beam effect
- View all at [flutterfx.com](https://flutterfx.com)

## Contributing

Found a bug? Have a suggestion? Feel free to open a PR at the [FlutterFX repository](https://github.com/flutterfx/flutterfx_widgets).

## License

MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [Amal Chandran](https://x.com/aml_chandran) | [FlutterFX](https://flutterfx.com)
