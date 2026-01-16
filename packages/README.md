# Widget Publishing Checklist

## Step 1: Create Package
```bash
cd packages
mkdir -p flutterfx_WIDGET_NAME/lib/src
mkdir -p flutterfx_WIDGET_NAME/example/lib
mkdir -p flutterfx_WIDGET_NAME/screenshots
```

## Step 2: Copy Files from blur_fade as Template
```bash
cp flutterfx_blur_fade/pubspec.yaml flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/README.md flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/CHANGELOG.md flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/LICENSE flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/analysis_options.yaml flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/.gitignore flutterfx_WIDGET_NAME/
cp flutterfx_blur_fade/lib/flutterfx_blur_fade.dart flutterfx_WIDGET_NAME/lib/flutterfx_WIDGET_NAME.dart
cp -r flutterfx_blur_fade/example/lib flutterfx_WIDGET_NAME/example/
cp flutterfx_blur_fade/example/pubspec.yaml flutterfx_WIDGET_NAME/example/
```

## Step 3: Update Files

| File | What to Change |
|------|----------------|
| `pubspec.yaml` | `blur_fade` → `WIDGET_NAME`, update description |
| `README.md` | Title, description, GIF link, usage examples |
| `lib/flutterfx_WIDGET_NAME.dart` | Library name, exports |
| `lib/src/` | Add widget code (clean, no `fx_` imports) |
| `example/pubspec.yaml` | `blur_fade` → `WIDGET_NAME` |
| `example/lib/main.dart` | Demo using new widget |

## Step 4: Add Screenshot
```bash
cp ../external_asset/showcase_WIDGET_NAME.gif screenshots/WIDGET_NAME_demo.gif
```

## Step 5: Generate Example Platforms
```bash
cd flutterfx_WIDGET_NAME/example
flutter create .
```

## Step 6: Test
```bash
flutter run
```

## Step 7: Publish
```bash
cd ..
dart pub publish --dry-run
dart pub publish
```

## Step 8: Submit to FlutterGems
https://fluttergems.dev/submit/

---

## Priority Order

- [x] blur_fade
- [ ] meteors
- [ ] border_beam
- [ ] hyper_text
- [ ] typing_animation
- [ ] neon_card
- [ ] orbit
- [ ] particles
- [ ] celebrate
- [ ] text_rotate



add to fluttergems