import 'dart:io';

import 'package:migrant_source_fs/migrant_source_fs.dart';

Future<void> main() async {
  final format = FileNameFormat(RegExp(r'\d{4}'));
  var directory = Directory('example/migrations');
  final migrations = LocalDirectory(directory, format);
  print('Reading all migrations from $directory:');

  await migrations.read().forEach((it) {
    print('Version ${it.version}: ${it.statement}');
  });
}
