import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';

import 'prompt.dart';

class Choice {
  const Choice({required this.name, required this.value, this.description, this.disabled = false});

  final String name;
  final String value;
  final String? description;
  final bool disabled;
}

class Select extends Prompt {
  Select(super.message, {super.required, super.validate, required this.children, super.defaultValue});

  final List<Choice> children;

  @override
  int build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
