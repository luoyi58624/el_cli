import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';

import 'input.dart';
import 'prompt.dart';

class Password extends Input {
  Password(super.message, {super.validate, super.defaultValue});

  @override
  String build() => result;
}
