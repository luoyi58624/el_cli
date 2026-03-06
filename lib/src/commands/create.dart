import 'dart:io';

import 'package:args/command_runner.dart';

class CreateCommand extends Command {
  @override
  final name = 'create';

  @override
  final description = 'install package';

  CreateCommand() {
    argParser.addFlag('global', abbr: 'g', help: 'Install global package', negatable: true);
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
        // 全局安装：dart pub global activate <package>
        print('🌍 Installing $packageName globally...');
        final result = await Process.run('dart', ['pub', 'global', 'activate', packageName]);
        if (result.exitCode != 0) {
          throw Exception('Global activation failed');
        }
        print('✅ Successfully installed $packageName globally');
      } else {
        // 本地安装：dart pub add <package>
        print('📦 Installing $packageName locally...');
        final result = await Process.run('dart', ['pub', 'add', packageName]);
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
