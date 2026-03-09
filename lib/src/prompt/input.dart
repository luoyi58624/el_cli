part of 'index.dart';

/// 输入对话框
class Input extends Prompt<String> {
  Input(super.message, {super.validate, this.defaultValue}) : super(required: true) {
    super.result = defaultValue;
  }

  final String? defaultValue;

  @override
  String build() => result!;
}
