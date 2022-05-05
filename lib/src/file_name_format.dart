/// Defines the format of the file name.
class FileNameFormat {
  /// All files containing the migrations must satisfy two rules:
  /// - the file name must begin with [versionFormat]
  /// - the file extension must match the [extension]
  ///
  /// Examples of the version format:
  /// - `RegExp(r'\d{4}')` - a 4-digit number with leading zeros
  /// - `RegExp(r'\d{4}-\d{2}-\d{2}')` - a date
  FileNameFormat(RegExp versionFormat, {String extension = '.sql'})
      : _extension = extension,
        _versionFormat = versionFormat;

  final RegExp _versionFormat;

  final String _extension;

  /// Matches the [fileName] against the format,
  /// returns the version if successful.
  String? parseVersion(String fileName) {
    if (!fileName.endsWith(_extension)) return null;
    return _version(fileName);
  }

  /// Returns true if [version] has correct format.
  bool isValidVersion(String version) => _version(version) == version;

  String? _version(String value) =>
      _versionFormat.matchAsPrefix(value)?.group(0);
}
