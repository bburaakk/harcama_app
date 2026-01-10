import 'package:math_expressions/math_expressions.dart';

double calculate(String input) {
  final parser = Parser();
  final exp = parser.parse(input);
  return exp.evaluate(EvaluationType.REAL, ContextModel());
}