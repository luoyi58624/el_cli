import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:io/ansi.dart';
import 'package:meta/meta.dart';

typedef PromptValidate = String? Function(String? value);

/// 终端控制台对话框
abstract class Prompt<T> extends Console {
  Prompt(String message, {this.defaultValue, this.required = false, this.validate}) : _message = message {
    ask();
    listenKeyboard();
    if (result != '' || defaultValue != null) confim();
  }

  /// 交互标题内容
  String get message => _message;
  final String _message;

  /// 默认值
  final T? defaultValue;

  /// 是否必填
  final bool required;

  /// 自定义验证，返回值如果不为 null，则会显示错误消息
  final PromptValidate? validate;

  String? _errorMessage;

  /// 错误消息，如果不为 null，会在终端最下方显示此消息
  @protected
  String? get errorMessage => _errorMessage;

  /// 设置错误消息，此方法会自动更新终端错误消息内容
  @protected
  set errorMessage(String? v) {
    final oldCol = cursorPosition!.col;
    if (v != null) {
      if (_errorMessage == null) {
        stdout.writeln();
        stdout.write(red.wrap(v));
        cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
      } else {
        cursorPosition = Coordinate(cursorPosition!.row + 1, 0);
        stdout.write(red.wrap(v));
        cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
      }
    } else {
      if (_errorMessage != null) {
        cursorPosition = Coordinate(cursorPosition!.row + 1, 0);
        eraseLine();
        cursorPosition = Coordinate(cursorPosition!.row - 1, oldCol);
      }
    }
    _errorMessage = v;
  }

  /// 用户输入的按键内容
  @protected
  String result = '';

  /// 构建对话结果
  T build();

  /// 构建询问交互
  @protected
  void ask() {
    stdout.write(blue.wrap('? '));
  }

  /// 通过验证时，更新 [ask] 的状态
  @protected
  void confim() {
    cursorPosition = Coordinate(cursorPosition!.row, 0);
    stdout.write(green.wrap('✔ '));
  }

  /// 处理回车键
  @protected
  void handlerEnter() {}

  /// 处理删除键
  @protected
  void handlerBackspace() {}

  /// 处理空格键
  @protected
  void handlerSpace() {}

  /// 处理方向键
  @protected
  void handlerDirection(String char) {}

  /// 处理符号键
  @protected
  void handlerChar(String char) {}

  /// 执行输入内容验证
  @protected
  void handlerValidate() {
    String? err;
    if (required && result.trim().isEmpty && defaultValue == null) err = 'required';
    if (err == null && validate != null) err = validate!(result);
    errorMessage = err;
  }

  /// 监听键盘按键
  @protected
  void listenKeyboard() {
    while (true) {
      final key = readKey();

      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter) {
          handlerValidate();

          if (errorMessage == null) {
            handlerEnter();
            break;
          }
        } else if (key.controlChar == ControlCharacter.backspace) {
          handlerBackspace();
          handlerValidate();
        } else if (key.controlChar == ControlCharacter.ctrlC) {
          exit(1);
        }
      } else {
        handlerChar(key.char);
        handlerValidate();
      }
    }
  }
}
