import 'dart:io';

const floor = 74;

void main(List<String> args) {
  final report = File(args.isEmpty ? 'coverage/lcov.info' : args.single);
  if (!report.existsSync()) {
    stderr.writeln('Missing coverage report. Run flutter test --coverage.');
    exitCode = 1;
    return;
  }

  var include = false;
  var found = 0;
  var hit = 0;
  final generated = RegExp(r'/generated/|\.(g|freezed)\.dart$');
  for (final line in report.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3).replaceAll(r'\', '/');
      include = !generated.hasMatch(path);
    }
    if (include && line.startsWith('LF:')) {
      found += int.parse(line.substring(3));
    }
    if (include && line.startsWith('LH:')) {
      hit += int.parse(line.substring(3));
    }
  }

  if (found == 0) {
    stderr.writeln('The report contains no non-generated lines.');
    exitCode = 1;
    return;
  }

  final percent = 100 * hit / found;
  stdout.writeln(
    '$hit/$found lines (${percent.toStringAsFixed(2)}%, floor $floor%)',
  );
  if (percent < floor) exitCode = 1;
}
