part of 'index.dart';

class Choice {
  const Choice({required this.name, required this.value, this.description, this.disabled = false});

  final String name;
  final String value;
  final String? description;
  final bool disabled;
}

/// 选择一组内容对话框
class Select extends Prompt<int> {
  Select(super.message, {super.required, super.validate, required this.choices, this.defaultValue}) {
    ask();
    final result = readNowrap();
    if (result != null) {
      confim();
    } else {}
  }

  final List<Choice> choices;
  final String? defaultValue;

  @override
  int build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
