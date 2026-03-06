import 'package:args/command_runner.dart';
import 'package:el_cli/el_cli.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner('el', 'Command-line tool for El framework')
    ..addCommand(CreateCommand())
    ..addCommand(InstallCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(ListCommand())
    ..addCommand(VersionCommand());

  try {
    await runner.run(arguments);
  } catch (e) {
    print('Error: $e');
  }
}
