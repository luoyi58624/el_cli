import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';

import 'prompt.dart';
import 'select.dart';

class Checkbox extends Prompt<int> {
  Checkbox(super.message, {super.required, super.validate, required this.children, super.defaultValue});

  final List<Choice> children;

  @override
  int build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
