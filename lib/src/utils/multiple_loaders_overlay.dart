import 'package:flutter/material.dart';

/// A utility class to display a loading overlay dialog in a Flutter app.
/// 
/// This is useful when you want to block user interaction while a background
/// task is running and show one of the beautiful loaders from this package.
class MultipleLoaders {
  static bool _isShowingOverlay = false;

  /// Shows a modal loading overlay dialog.
  /// 
  /// The [loader] widget is displayed in the center of the screen.
  /// Set [barrierDismissible] to true if you want the user to be able
  /// to dismiss the dialog by tapping outside of it (defaults to false).
  /// [barrierColor] defines the background color overlay.
  static void showOverlay(
    BuildContext context, {
    required Widget loader,
    bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
  }) {
    if (_isShowingOverlay) return;

    _isShowingOverlay = true;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        // WillPopScope is deprecated, using PopScope
        return PopScope(
          canPop: barrierDismissible,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: loader,
            ),
          ),
        );
      },
    ).then((_) {
      _isShowingOverlay = false;
    });
  }

  /// Hides the loading overlay dialog if it is currently showing.
  static void hideOverlay(BuildContext context) {
    if (_isShowingOverlay) {
      Navigator.of(context, rootNavigator: true).pop();
      _isShowingOverlay = false;
    }
  }
}
