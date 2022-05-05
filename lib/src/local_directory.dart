import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant_source_fs/src/file_name_format.dart';
import 'package:migrant_source_fs/src/migration_file.dart';

/// Reads migrations from a local filesystem.
class LocalDirectory extends MigrationSource {
  LocalDirectory(this._dir, this._format);

  final Directory _dir;
  final FileNameFormat _format;

  @override
  Stream<Migration> read({String? afterVersion}) async* {
    if (afterVersion != null && !_format.isValidVersion(afterVersion)) {
      throw FormatException('Invalid version format.');
    }
    final entries = await _dir.list().toList();
    final migrations = entries
        .whereType<File>()
        .map((file) {
          final name = file.uri.pathSegments.last;
          final match = _format.parseVersion(name);
          if (match == null) return null;
          return MigrationFile(file, match);
        })
        .whereType<MigrationFile>()
        .where((matchedFile) =>
            afterVersion == null ||
            matchedFile.version.compareTo(afterVersion) > 0)
        .toList();
    migrations.sort();

    for (final migration in migrations) {
      yield Migration(migration.version, await migration.file.readAsString());
    }
  }
}
