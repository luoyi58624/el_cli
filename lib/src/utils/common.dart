import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

/// 读取本地 pubspec.yaml 对象
Future<Pubspec> getLocalPubspec() async {
  final pubspecFile = File('pubspec.yaml');

  if (!await pubspecFile.exists()) {
    throw 'pubspec.yaml not found';
  }

  final content = await pubspecFile.readAsString();
  final pubspec = Pubspec.parse(content);

  return pubspec;
}
