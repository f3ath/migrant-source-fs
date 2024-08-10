import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant_source_fs/src/file_name_format.dart';

/// Reads migrations from a local filesystem.
/// Returns the number of loaded migrations.
class LocalFilesystem implements MigrationSource {
  final _migrations = <Migration>[];

  Future<int> load(Directory dir, FileNameFormat format) async {
    await for (final file in dir.list()) {
      if (file is! File) continue;
      final version = format.parseVersion(file.uri.pathSegments.last);
      if (version == null) continue;
      _migrations.add(Migration(version, [await file.readAsString()]));
    }
    _migrations.sort((a, b) => a.version.compareTo(b.version));
    return _migrations.length;
  }

  @override
  Future<Migration> getInitial() async => _migrations.first;

  @override
  Future<Migration?> getNext(String version) async {
    if (_migrations.isEmpty) throw StateError('No migrations loaded');
    final index = _migrations.indexWhere((it) => it.version == version);
    if (index == -1) throw ArgumentError('Unknown version: $version');
    return index + 1 < _migrations.length ? _migrations[index + 1] : null;
  }
}
