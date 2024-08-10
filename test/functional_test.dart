import 'dart:io';

import 'package:migrant_source_fs/migrant_source_fs.dart';
import 'package:test/test.dart';

void main() async {
  final source = LocalFilesystem();
  await source.load(Directory('test/migrations'), FileNameFormat(RegExp(r'\d{4}')));

  group('Read', () {
    test('First', () async {
      final m0 = await source.getInitial();
      expect(m0.version, equals('0000'));
      expect(m0.statements, equals(['create table foo (id text not null);']));
    });

    test('Next', () async {
      final m1 = await source.getNext('0000');
      expect(m1?.version, equals('0001'));
      expect(m1?.statements, equals(['alter table foo add column name text;']));
      final m2 = await source.getNext('0001');
      expect(m2?.version, equals('0002'));
      expect(m2?.statements, equals(['drop table foo;']));
      final m3 = await source.getNext('0002');
      expect(m3, isNull);
    });
  });

}
