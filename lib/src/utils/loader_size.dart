/// Enum representing the possible sizes of a loader.
enum LoaderSize {
  /// Extra small size (16.0).
  extraSmall(16.0),

  /// Small size (24.0).
  small(24.0),

  /// Medium size (32.0).
  medium(32.0),

  /// Large size (48.0).
  large(48.0),

  /// Extra large size (64.0).
  extraLarge(64.0),

  /// Custom size with the specified value.
  custom(0.0);

  /// The numerical value associated with this size.
  final double value;

  /// Constructor for [LoaderSize].
  const LoaderSize(this.value);
}
