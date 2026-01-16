# BlurFade

[![pub package](https://img.shields.io/pub/v/flutterfx_blur_fade.svg)](https://pub.dev/packages/flutterfx_blur_fade)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue.svg)](https://flutter.dev)

A Flutter widget that animates children with a smooth combined blur and fade effect. Part of the [FlutterFX](https://flutterfx.com) collection.

![BlurFade Demo](https://github.com/flutterfx/flutterfx_widgets/blob/main/external_asset/showcase_blurfade.gif?raw=true)

## Features

- 🎬 Smooth blur-to-sharp transition combined with fade-in
- ⚡ Zero external dependencies - just Flutter
- 🎛️ Customizable duration, delay, curve, and blur intensity
- 📱 Works on all platforms (iOS, Android, Web, Desktop)
- ♿ Respects accessibility settings

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
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 200),
  blur: 12.0,
  curve: Curves.easeInOut,
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Animated Content'),
  ),
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
| `duration` | `Duration` | `400ms` | Animation duration |
| `delay` | `Duration` | `0ms` | Delay before animation starts |
| `curve` | `Curve` | `Curves.easeOut` | Animation curve |
| `blur` | `double` | `8.0` | Maximum blur sigma value |

## How It Works

The animation uses two overlapping phases:
1. **Opacity** (0% - 60% of duration): Fades the widget in
2. **Blur** (40% - 100% of duration): Transitions from blurred to sharp

This overlap creates a seamless, polished effect.

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
