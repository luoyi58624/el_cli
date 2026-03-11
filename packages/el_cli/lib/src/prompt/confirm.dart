import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:el_cli/el_cli.dart';
import 'package:io/ansi.dart';

import 'prompt.dart';

class Confirm extends Prompt {
  Confirm(super.message, {super.defaultValue = false}) : assert(defaultValue != null);

  @override
  bool get defaultValue => super.defaultValue as bool;

  @override
  String get message => '${super.message} ${defaultValue ? '(Y/n)' : '(y/N)'} ';

  @override
  bool build() {
    final v = result;
    if (v == 'y' || v == 'Y' || v.toLowerCase() == 'yes') return true;
    if (v == 'n' || v == 'N' || v.toLowerCase() == 'no') return false;
    return defaultValue;
  }
}
