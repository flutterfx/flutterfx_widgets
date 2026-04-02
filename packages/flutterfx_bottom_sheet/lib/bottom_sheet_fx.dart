/// FlutterFX Bottom Sheet
///
/// A smooth, draggable bottom sheet widget with scale-and-slide entrance
/// animation and a fully customizable style system.
///
/// ## Quick start
///
/// ```dart
/// import 'package:bottom_sheet_fx/bottom_sheet_fx.dart';
///
/// final _controller = FxBottomSheetController();
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SafeArea(
///       bottom: false,
///       child: FxBottomSheet(
///         controller: _controller,
///         mainContent: MyMainScreen(),
///         drawerContent: MySheetContent(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// ## Custom style
///
/// ```dart
/// FxBottomSheet(
///   style: FxBottomSheetStyle.dark().copyWith(
///     topBorderRadius: 28,
///     mainContentScale: 0.90,
///   ),
///   maxHeight: 0.80,
///   controller: _controller,
///   mainContent: MyMainScreen(),
///   drawerContent: MySheetContent(),
/// )
/// ```
library bottom_sheet_fx;

export 'src/fx_bottom_sheet.dart'
    show FxBottomSheet, FxBottomSheetController, FxBottomSheetStyle;
