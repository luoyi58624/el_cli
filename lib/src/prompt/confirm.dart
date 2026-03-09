import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';

import 'prompt.dart';

class Confirm extends Prompt<bool> {
  Confirm(super.message, {super.defaultValue = false}) : assert(defaultValue != null);

  @override
  String get message => '${super.message} ${defaultValue! ? '(Y/n)' : '(y/N)'} ';

  @override
  bool build() {
    final v = result;
    if (v == 'y' || v == 'Y' || v.toLowerCase() == 'yes') return true;
    if (v == 'n' || v == 'N' || v.toLowerCase() == 'no') return false;
    return defaultValue!;
  }
}
