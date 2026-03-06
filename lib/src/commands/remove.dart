import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart';

import '../utils/common.dart';

class RemoveCommand extends Command {
  @override
  final name = 'r';

  @override
  final description = 'remove package';

  RemoveCommand() {
    argParser.addFlag('global', abbr: 'g', help: 'Remove global package', negatable: false);
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final packageName = args.rest.isNotEmpty ? args.rest[0] : null;
    final isGlobal = args['global'] == true;

    if (packageName == null) {
      print('❌ Error: Package name is required');
      print('Usage: r [-g] <package_name>');
      return;
    }

    try {
      if (isGlobal) {
        print('🌍 Removing $packageName globally...');
        final result = await Process.run('dart', ['pub', 'global', 'deactivate', packageName]);
        if (result.exitCode != 0) {
          throw Exception('Global activation failed');
        }
        print('✅ Successfully remove $packageName globally');
      } else {
        print('📦 Removing $packageName locally...');
        final pubspec = await getLocalPubspec();
        ProcessResult result;

        if (pubspec.dependencies.containsKey('flutter')) {
          var shell = Shell();
          final results = await shell.run('flutter pub remove $packageName');
          result = results.first;
        } else {
          result = await Process.run('dart', ['pub', 'remove', packageName]);
        }

        if (result.exitCode != 0) {
          throw Exception('Local remove failed');
        }
        print('✅ Successfully remove $packageName locally');
      }
    } catch (e) {
      print('❌ Installation failed: $e');
    }
  }
}
