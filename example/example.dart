import 'dart:io';

import 'package:migrant_source_fs/migrant_source_fs.dart';

Future<void> main() async {
  final format = FileNameFormat(RegExp(r'\d{4}'));
  final directory = Directory('example/migrations');
  final migrations = LocalFilesystem();
  print('Reading all migrations from $directory:');
  final number = await migrations.load(directory, format);
  print('Loaded $number migrations');
  final initial = await migrations.getInitial();
  print('Initial migration:');
  print('Version ${initial.version}: ${initial.statements}');
  var version = initial.version;
  while (true) {
    final next = await migrations.getNext(version);
    if (next == null) break;
    print('Next migration:');
    print('Version ${next.version}: ${next.statements}');
    version = next.version;
  }
}
