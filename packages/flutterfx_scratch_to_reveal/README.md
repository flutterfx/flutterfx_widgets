# ScratchToReveal

[![pub package](https://img.shields.io/pub/v/flutterfx_scratch_to_reveal.svg)](https://pub.dev/packages/flutterfx_scratch_to_reveal)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue.svg)](https://flutter.dev)

A Flutter widget that reveals hidden content through a scratch gesture, with a customizable gradient overlay and a satisfying completion animation. Part of the [FlutterFX](https://flutterfx.com) collection.

![ScratchToReveal Demo](https://github.com/flutterfx/flutterfx_widgets/blob/main/external_asset/showcase_scratch_to_reveal.gif?raw=true)

## Features

- 🎨 Fully customizable gradient overlay (any number of colors)
- 🖐️ Natural scratch gesture using pan input
- ✅ Configurable completion threshold (% of area scratched)
- 🎉 Built-in pop/wiggle animation on reveal
- 📳 Optional haptic feedback while scratching
- ⚡ Zero external dependencies — just Flutter
- 📱 Works on all platforms (iOS, Android, Web, Desktop)

## Installation

```bash
flutter pub add flutterfx_scratch_to_reveal
```

Or add to your `pubspec.yaml`:

```yaml
dependencies:
  flutterfx_scratch_to_reveal: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutterfx_scratch_to_reveal/flutterfx_scratch_to_reveal.dart';

ScratchToReveal(
  width: 250,
  height: 250,
  child: Center(
    child: Text('🎉', style: TextStyle(fontSize: 120)),
  ),
)
```

### With Customization

```dart
ScratchToReveal(
  width: 300,
  height: 200,
  minScratchPercentage: 60,
  gradientColors: const [
    Color(0xFF00C6FF),
    Color(0xFF0072FF),
  ],
  enableHapticFeedback: true,
  onComplete: () {
    print('Fully revealed!');
  },
  child: Container(
    color: Colors.grey[900],
    child: Center(child: Text('You won!')),
  ),
)
```

### Reset / Replay

Wrap `ScratchToReveal` in a `ValueKey` and update the key to reset the scratch state:

```dart
ScratchToReveal(
  key: ValueKey(_resetCounter),
  width: 250,
  height: 250,
  child: YourWidget(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget` | **required** | The widget revealed after scratching |
| `width` | `double` | **required** | Width of the scratch area |
| `height` | `double` | **required** | Height of the scratch area |
| `minScratchPercentage` | `double` | `50` | Bounding-box coverage % that triggers completion |
| `gradientColors` | `List<Color>` | Purple → Pink → Peach | Colors for the gradient overlay |
| `onComplete` | `VoidCallback?` | `null` | Called after the reveal animation finishes |
| `enableHapticFeedback` | `bool` | `true` | Triggers selection haptics while scratching |

## How It Works

1. A gradient image is rendered onto an offscreen canvas using the provided `gradientColors`.
2. A `CustomPainter` draws that image on top of the child, using `BlendMode.clear` to erase the path as the user scratches.
3. Once the bounding box of the scratch path covers `minScratchPercentage` of the total area, a scale + wiggle animation plays and `onComplete` is called.

## More FlutterFX Widgets

Check out other widgets in the FlutterFX collection:

- [flutterfx_blur_fade](https://pub.dev/packages/flutterfx_blur_fade) - Smooth blur + fade entrance animation
- [flutterfx_meteors](https://pub.dev/packages/flutterfx_meteors) - Animated meteor shower effect
- [flutterfx_border_beam](https://pub.dev/packages/flutterfx_border_beam) - Animated border beam effect
- View all at [flutterfx.com](https://flutterfx.com)

## Contributing

Found a bug? Have a suggestion? Feel free to open a PR at the [FlutterFX repository](https://github.com/flutterfx/flutterfx_widgets).

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [Amal Chandran](https://x.com/aml_chandran) | [FlutterFX](https://flutterfx.com)
