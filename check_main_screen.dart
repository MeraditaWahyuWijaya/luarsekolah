import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Folder lib/ tidak ditemukan!');
    return;
  }

  print('Mulai analisis import MainScreen...\n');

  final dartFiles = libDir
      .listSync(recursive: true)
      .where((f) => f.path.endsWith('.dart'));

  for (var file in dartFiles) {
    final lines = File(file.path).readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('MainScreen')) {
        print('${file.path} : baris ${i + 1} -> ${lines[i].trim()}');
      }
    }
  }

  print('\nSelesai analisis.');
}
