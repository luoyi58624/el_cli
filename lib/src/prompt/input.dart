import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';

import 'prompt.dart';

class Input extends Prompt<String> {
  Input(super.message, {super.validate, super.defaultValue}) : super(required: true);

  @override
  String build() {
    if (result == '') {
      if (defaultValue != null) return defaultValue!;
    }
    return result;
  }

  @override
  void ask() {
    super.ask();
    stdout.write('$message ');
    _writeDefaultValue();
  }

  @override
  void confim() {
    super.confim();
    stdout.write('$message ');
    final v = result.trim() == '' ? defaultValue : result;
    if (v != null) stdout.writeln(cyan.wrap(v));
  }

  @override
  void handlerBackspace() {
    if (result != '') {
      final row = cursorPosition!.row;
      result = result.substring(0, result.length - 1);
      cursorPosition = Coordinate(row, cursorPosition!.col - 1);
      eraseCursorToEnd();
      if (result == '') _writeDefaultValue();
    } else {
      _writeDefaultValue();
    }
  }

  @override
  void handlerChar(String char) {
    if (result == '') {
      if (defaultValue != null) {
        eraseCursorToEnd();
      }
    }
    result += char;
    stdout.write(char);
  }

  /// 向终端写入默认值，显示默认值不影响光标输入位置
  void _writeDefaultValue() {
    if (defaultValue != null) {
      final oldCol = cursorPosition!.col;
      stdout.write(lightGray.wrap(defaultValue));
      cursorPosition = Coordinate(cursorPosition!.row, oldCol);
    }
  }
}
