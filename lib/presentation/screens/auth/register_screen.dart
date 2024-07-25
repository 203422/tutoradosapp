import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(colors.surface.value),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Text(
                    'Registrate',
                    style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.normal,
                        color: Color(colors.onSurface.value)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const RegisterFrom()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterFrom extends ConsumerWidget {
  const RegisterFrom({super.key});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.message.isEmpty) return;
      showSnackBar(context, next.message);
      if (next.authStatus == AuthStatus.newUserRegistred) context.go('/login');
    });

    return Form(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: 'Nombre',
            onChanged: ref.read(registerFormProvider.notifier).onNameChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.name.errorMessage
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: 'Apellido',
            onChanged: ref.read(registerFormProvider.notifier).onLastNameChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.lastName.errorMessage
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: 'Código o matrícula',
            onChanged: ref
                .read(registerFormProvider.notifier)
                .onStudentEnrollmentChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.studentEnrollment.errorMessage
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: 'Correo electrónico',
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: 'Contraseña',
            isObscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
            onFieldSubmitted: (_) =>
                ref.read(registerFormProvider.notifier).onFormSubmit(),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: registerForm.isPosting
                    ? null
                    : ref.read(registerFormProvider.notifier).onFormSubmit,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(colors.primary.value),
                    foregroundColor: Color(colors.onPrimary.value)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              )),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Ya tienes cuenta? ',
                style: TextStyle(
                    fontSize: 18, color: Color(colors.onSurface.value)),
              ),
              GestureDetector(
                onTap: () {
                  context.go('/login');
                },
                child: Text(
                  'Inicia Sesión',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(colors.onSurface.value)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class IsTutorOption extends ConsumerWidget {
  const IsTutorOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalProvider = ref.watch(medicalDataProvider);
    final colors = Theme.of(context).colorScheme;

    return SegmentedButton(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Color(colors.primary.value),
        selectedForegroundColor: Color(colors.onPrimary.value),
        shape: (ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12))),
      ),
      segments: const [
        ButtonSegment(
            value: false,
            label: Text(
              'No',
              style: TextStyle(fontSize: 16),
            )),
        ButtonSegment(
            value: true, label: Text('Sí', style: TextStyle(fontSize: 16))),
      ],
      selected: {medicalProvider.disease},
      onSelectionChanged: (newSelection) {
        ref
            .read(medicalDataProvider.notifier)
            .diseaseIsSelected(newSelection.first);
      },
    );
  }
}