import 'package:flutter/material.dart';

/// A custom wrapper around [FutureBuilder] that automatically shows a
/// loading widget while waiting for the future to resolve.
///
/// This greatly simplifies the boilerplate of writing `FutureBuilder`s
/// since you only need to provide the future, the loader to display,
/// and the builder for the success state.
class LoaderFutureBuilder<T> extends StatelessWidget {
  /// The future to wait for.
  final Future<T>? future;

  /// The loader widget from `flutter_multiple_loaders` to display while waiting.
  final Widget loader;

  /// The builder to display when the future has completed successfully.
  final Widget Function(BuildContext context, T data) builder;

  /// Optional builder to handle error states.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const LoaderFutureBuilder({
    super.key,
    required this.future,
    required this.loader,
    required this.builder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return Center(child: loader);
        } else if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder!(context, snapshot.error!);
          }
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        } else {
          return Center(child: loader);
        }
      },
    );
  }
}
