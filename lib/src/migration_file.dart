import 'dart:io';

/// A file containing a migration.
class MigrationFile implements Comparable<MigrationFile> {
  MigrationFile(this.file, this.version);

  final File file;

  final String version;

  @override
  int compareTo(MigrationFile other) => version.compareTo(other.version);
}
