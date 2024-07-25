import 'package:formz/formz.dart';

enum InputDoubleError { empty, noDoubleType }

class InputDouble extends FormzInput<double, InputDoubleError> {
  const InputDouble.pure() : super.pure(0);

  const InputDouble.dirty(double value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InputDoubleError.empty) return 'El campo es requerido';
    if (displayError == InputDoubleError.noDoubleType) return 'Solo se aceptan números';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  InputDoubleError? validator(double value) {
    if (value == 0) return InputDoubleError.empty;
    if (value.runtimeType != double) return InputDoubleError.noDoubleType;

    return null;
  }
}
