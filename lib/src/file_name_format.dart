/// Defines the format of the file name.
class FileNameFormat {
  FileNameFormat(this._versionFormat, {String extension = '.sql'})
      : _extension = extension;

  final RegExp _versionFormat;

  final String _extension;

  /// Matches the [name] against the format,
  /// returns the version if successful.
  String? readVersion(String name) {
    if (!name.endsWith(_extension)) return null;
    return _versionFormat.matchAsPrefix(name)?.group(0);
  }

  /// Returns true if [version] has correct format.
  bool isValidVersion(String version) =>
      _versionFormat.firstMatch(version)?.group(0) == version;
}
