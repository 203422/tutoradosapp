import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class AssignTutor extends ConsumerWidget {
  const AssignTutor({super.key});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(codeProvider, (previous, next) {
      if (next.message.isEmpty) return;
      showSnackbar(context, next.message);
    });

    final codeState = ref.watch(codeProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text('Ingresa el código de tu tutor',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.normal)),
        const SizedBox(
          height: 30,
        ),
        CustomTextField(
          label: 'Código',
          isFormStudent: true,
          onChanged: ref.read(codeProvider.notifier).onCodeChanged,
          errorMessage:
              codeState.isCodePosted ? codeState.code.errorMessage : null,
          onFieldSubmitted: (_) =>
              ref.read(codeProvider.notifier).onCodeSubmit(),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(colors.primary.value),
                  foregroundColor: Color(colors.onPrimary.value)),
              onPressed: codeState.isCodePosting
                  ? null
                  : ref.read(codeProvider.notifier).onCodeSubmit,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Siguiente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
        ),
      ],
    );
  }
}
