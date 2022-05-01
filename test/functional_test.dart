import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant_source_fs/migrant_source_fs.dart';
import 'package:test/test.dart';

void main() {
  final source = LocalDirectory(
      Directory('test/migrations'), FileNameFormat(RegExp(r'\d{4}')));
  final m0 = Migration('0000', 'create table foo (id text not null);');
  final m1 = Migration('0001', 'alter table foo add column name text;');
  final m2 = Migration('0002', 'drop table foo;');

  test('Read', () async {
    expect(await source.read().toList(), equals([m0, m1, m2]));
    expect(await source.read(afterVersion: '0000').toList(), equals([m1, m2]));
    expect(await source.read(afterVersion: '0001').toList(), equals([m2]));
    expect(await source.read(afterVersion: '0002').toList(), isEmpty);
    expect(await source.read(afterVersion: '0003').toList(), isEmpty);
  });

  test('Invalid version format', () async {
    expect(() => source.read(afterVersion: '').toList(), throwsFormatException);
    expect(
        () => source.read(afterVersion: 'abc').toList(), throwsFormatException);
    expect(() => source.read(afterVersion: '00001').toList(),
        throwsFormatException);
    expect(() => source.read(afterVersion: '0000x').toList(),
        throwsFormatException);
    expect(() => source.read(afterVersion: 'x0000').toList(),
        throwsFormatException);
  });
}
