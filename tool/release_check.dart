import 'dart:io';

class CheckItem {
  final String label;
  final bool Function() verify;

  const CheckItem(this.label, this.verify);
}

void main() {
  final checks = <CheckItem>[
    CheckItem('pubspec.yaml exists', () => File('pubspec.yaml').existsSync()),
    CheckItem('Version is set', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      return pubspec.contains(RegExp(r'version:\s*\d+\.\d+\.\d+\+\d+'));
    }),
    CheckItem('Android folder exists', () => Directory('android').existsSync()),
    CheckItem('Workflow exists', () => File('.github/workflows/release.yml').existsSync()),
    CheckItem('Main app exists', () => File('lib/main.dart').existsSync()),
  ];

  var passed = 0;

  print('Release Checklist Report');
  print('------------------------');

  for (final check in checks) {
    final ok = check.verify();
    if (ok) passed++;

    print('${ok ? "✓" : "✗"} ${check.label}');
  }

  print('------------------------');
  print('$passed/${checks.length} checks passed');

  if (passed != checks.length) {
    exit(1);
  }
}