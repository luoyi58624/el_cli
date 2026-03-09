import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';
import 'package:meta/meta.dart';

part 'confirm.dart';

part 'input.dart';

part 'select.dart';

typedef PromptValidate = String? Function(String? value);

/// 终端控制台对话框
abstract class Prompt<T> extends Console {
  Prompt(String message, {this.required = false, this.validate}) : _message = message {
    ask();
    final result = readNowrap();
    if (result != null) {
      confim();
    } else {}
  }

  /// 交互标题内容
  String get message => _message;
  final String _message;

  /// 是否必填
  final bool required;

  /// 自定义验证，返回值如果不为 null，则会显示错误消息
  final PromptValidate? validate;

  /// 构建对话结果
  T build();

  @protected
  bool hasError = false;

  @protected
  String? result;

  /// 构建询问交互
  @protected
  void ask() {
    stdout.write(blue.wrap('? '));
    stdout.write('$message ');
  }

  /// 通过验证时，更新 [ask] 的状态
  @protected
  void confim() {
    cursorPosition = Coordinate(cursorPosition!.row, 0);
    stdout.write(green.wrap('✔ '));
    stdout.write('$message ');
    stdout.writeln(cyan.wrap(result));
  }

  @protected
  String? readNowrap() {
    final buffer = StringBuffer();
    while (true) {
      final key = readKey();
      final oldCol = cursorPosition!.col;
      if (hasError) {
        cursorPosition = Coordinate(cursorPosition!.row + 1, 0);
        eraseLine();
        cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
      }
      hasError = false;

      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter) {
          if (required) {
            if (buffer.toString().trim().isEmpty) {
              hasError = true;

              stdout.writeln();
              stdout.write(red.wrap('required'));
              cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
            }
          }

          if (hasError != true && validate != null) {
            final err = validate!(buffer.toString());
            if (err != null) {
              hasError = true;
              stdout.writeln();
              stdout.write(red.wrap(err));
              cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
            }
          }

          if (!hasError) {
            result = buffer.toString();
            return result;
          }
        } else if (key.controlChar == ControlCharacter.backspace) {
          if (buffer.isNotEmpty) {
            final row = cursorPosition!.row;
            final current = buffer.toString();
            final newStr = current.substring(0, current.length - 1);
            buffer.clear();
            buffer.write(newStr);
            cursorPosition = Coordinate(row, cursorPosition!.col - 1);
            stdout.write(' ');
            cursorPosition = Coordinate(row, cursorPosition!.col - 1);
          }
        } else if (key.controlChar == ControlCharacter.ctrlC) {
          exit(1);
        }
      } else {
        buffer.write(key);
        write(key);
      }
    }
  }
}
