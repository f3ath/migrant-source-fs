/// Defines the format of the file name.
/// All files containing the migrations must satisfy two rules:
/// - the file name must begin with [versionFormat]
/// - the file extension must match the [extension]
///
/// Examples of the version format:
/// - `RegExp(r'\d{4}')` - a 4-digit number with leading zeros
/// - `RegExp(r'\d{4}-\d{2}-\d{2}')` - a date
class FileNameFormat {
  FileNameFormat(RegExp versionFormat, {String extension = '.sql'})
      : _extension = extension,
        _versionFormat = versionFormat;

  final RegExp _versionFormat;

  final String _extension;

  /// Matches the [fileName] against the format,
  /// returns the version if successful.
  String? parseVersion(String fileName) => fileName.endsWith(_extension)
      ? _versionFormat.matchAsPrefix(fileName)?.group(0)
      : null;
}
