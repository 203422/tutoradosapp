import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Color(colors.background.value),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text('Bienvenido',
                            style: TextStyle(
                                color: Color(colors.onSurface.value),
                                fontSize: 54,
                                fontWeight: FontWeight.normal)),
                        Text(
                          'Por favor ingresa tus datos',
                          style: TextStyle(
                              color: Color(colors.onSurface.value),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const LoginForm()
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.message.isEmpty) return;
      showSnackbar(context, next.message);
    });

    return Form(
        child: Column(
      children: [
        CustomTextField(
          label: 'Matrícula o correo electrónico',
          onChanged: ref.read(loginFormProvider.notifier).onIdentifierChanged,
          errorMessage:
              loginForm.isFormPosted ? loginForm.identifier.errorMessage : null,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          isObscureText: true,
          label: 'Contraseña',
          onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
          onFieldSubmitted: (_) =>
              ref.read(loginFormProvider.notifier).onFormSubmit(),
          errorMessage:
              loginForm.isFormPosted ? loginForm.password.errorMessage : null,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loginForm.isPosting
                  ? null
                  : ref.read(loginFormProvider.notifier).onFormSubmit,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(colors.primary.value),
                  foregroundColor:  Color(colors.onPrimary.value)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Entrar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            )),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No tienes cuenta? ',
              style: TextStyle(
                  fontSize: 18, color: Color(colors.onSurface.value)),
            ),
            GestureDetector(
              onTap: () {
                context.go('/register');
              },
              child: Text(
                'Crear ahora',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(colors.onSurface.value)),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
