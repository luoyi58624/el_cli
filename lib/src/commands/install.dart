import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

import '../utils/common.dart';

class InstallCommand extends Command {
  @override
  final name = 'i';

  @override
  final description = 'install package';

  InstallCommand() {
    argParser.addFlag('global', abbr: 'g', help: 'Install global package', negatable: false);
  }

  @override
  Future<void> run() async {
    final args = argResults!;
    final packageName = args.rest.isNotEmpty ? args.rest[0] : null;
    final isGlobal = args['global'] == true;

    if (packageName == null) {
      print('❌ Error: Package name is required');
      print('Usage: i [-g] <package_name>');
      return;
    }

    try {
      if (isGlobal) {
        print('🌍 Installing $packageName globally...');
        final result = await Process.run('dart', ['pub', 'global', 'activate', packageName]);
        if (result.exitCode != 0) {
          throw Exception('Global activation failed');
        }
        print('✅ Successfully installed $packageName globally');
      } else {
        print('📦 Installing $packageName locally...');
        final pubspec = await getLocalPubspec();
        ProcessResult result;
        if (pubspec.dependencies.containsKey('flutter')) {
          var shell = Shell();
          final results = await shell.run('flutter pub add $packageName');
          result = results.first;
        } else {
          result = await Process.run('dart', ['pub', 'add', packageName], runInShell: true);
        }

        if (result.exitCode != 0) {
          throw Exception('Local installation failed');
        }
        print('✅ Successfully installed $packageName locally');
      }
    } catch (e) {
      print('❌ Installation failed: $e');
    }
  }
}
