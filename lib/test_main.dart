import 'dart:io';
import 'package:harcama_app/domain/utility/math_helper.dart';

void main() {
  print("İfade gir (çıkmak için exit yaz):");

  while (true) {
    stdout.write("> ");
    final input = stdin.readLineSync();

    if (input == null) continue;
    if (input.toLowerCase() == 'exit') break;

    try {
      final result = calculate(input);
      print("Sonuç: $result");
    } catch (e) {
      print("Hatalı ifade");
    }
  }
}
