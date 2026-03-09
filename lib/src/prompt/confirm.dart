part of 'index.dart';

/// 确认对话框
class Confirm extends Prompt<bool> {
  Confirm(super.message, {this.defaultValue = false}) {
    ask();
    final result = readNowrap();
    if (result != null) {
      confim();
    } else {}
  }

  final bool defaultValue;

  @override
  String get message => '${super.message} ${defaultValue ? '(Y/n)' : '(y/N)'} ';

  @override
  bool build() {
    final v = result!;
    if (v == 'y' || v == 'Y' || v.toLowerCase() == 'yes') return true;
    if (v == 'n' || v == 'N' || v.toLowerCase() == 'no') return false;
    return defaultValue;
  }
}
