# Publishing to pub.dev

This guide covers how to publish the Flutter Multiple Loaders package to [pub.dev](https://pub.dev), the official package repository for Dart and Flutter packages.

## Preparation

1. Update `pubspec.yaml`
   - Ensure all package information is correct
   - Update version number if needed
   - Check dependencies

2. Documentation
   - Update README.md with latest information
   - Make sure CHANGELOG.md is updated with changes in this version
   - Verify LICENSE file is present and correct

3. Verify Package Quality
   - Run tests: `flutter test`
   - Format code: `dart format .`
   - Run analysis: `flutter analyze`
   - Run example app to verify functionality

## Publishing Process

1. Create a pub.dev account if you don't have one
   - Visit [pub.dev](https://pub.dev)
   - Sign in with a Google account

2. Verify package format
   ```bash
   flutter pub publish --dry-run
   ```
   This checks for issues without actually publishing. Fix any errors that appear.

3. Publish the package
   ```bash
   flutter pub publish
   ```

4. Verify publication
   - Visit your package page on pub.dev
   - Check that all information and links are correct
   - Verify documentation renders properly

## Updating the Package

To update an existing package:

1. Make your code changes
2. Update the version in `pubspec.yaml` following [semantic versioning](https://semver.org/)
   - Increment MAJOR version for incompatible API changes
   - Increment MINOR version for new functionality that's backwards compatible
   - Increment PATCH version for backwards compatible bug fixes
3. Update the CHANGELOG.md with the changes made
4. Run the verification steps above
5. Publish with `flutter pub publish`

## Tips for Better Package Score

pub.dev assigns a score to packages based on:

- **Maintenance**: How recently and frequently maintained
- **Health**: Code quality, analysis results
- **Documentation**: Quality and presence of documentation
- **Popularity**: How often downloaded, used by other packages

To improve your score:

- **Documentation**: Provide clear and comprehensive documentation
- **Code Quality**: Address all linting issues
- **Testing**: Add thorough test coverage
- **Example**: Include a well-documented example app
- **Regular Updates**: Keep the package updated regularly
- **CI/CD**: Set up GitHub Actions or similar for automated testing

## Resources

- [Dart Package Publishing Documentation](https://dart.dev/tools/pub/publishing)
- [Pub.dev Publishing Documentation](https://pub.dev/help/publishing)
- [Semantic Versioning](https://semver.org/)
- [Flutter Package Development Guide](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
