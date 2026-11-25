import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 1 || !const {'seed', 'clean'}.contains(args.single)) {
    stderr.writeln(
      'Usage: dart run tool/contribution_fixtures.dart seed|clean',
    );
    exitCode = 1;
    return;
  }

  final containers = await Process.run('docker', [
    'ps',
    '--filter',
    'label=com.docker.compose.project=ronditrack-assignment121',
    '--filter',
    'label=com.docker.compose.service=db',
    '--format',
    '{{.ID}}',
  ]);
  final ids = const LineSplitter()
      .convert((containers.stdout as String).trim())
      .where((id) => id.isNotEmpty)
      .toList();
  if (containers.exitCode != 0 || ids.length != 1) {
    stderr.writeln('Start the dedicated ronditrack-assignment121 project.');
    exitCode = 1;
    return;
  }

  final script = await File('tool/${args.single}-contributions.sql')
      .readAsString();
  final psql = await Process.start('docker', [
    'exec',
    '-i',
    ids.single,
    'psql',
    '-X',
    '-v',
    'ON_ERROR_STOP=1',
    '-U',
    'ronditrack',
    '-d',
    'ronditrack',
  ]);
  final output = Future.wait([
    stdout.addStream(psql.stdout),
    stderr.addStream(psql.stderr),
  ]);
  psql.stdin.writeln(script);
  await psql.stdin.close();
  await output;
  exitCode = await psql.exitCode;
}
