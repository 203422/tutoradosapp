import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class RegisterTutorScreen extends ConsumerWidget {
  const RegisterTutorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final codesState = ref.watch(codesProvider);
    return Scaffold(
      backgroundColor: Color(colors.surface.value),
      appBar: AppBar(
        backgroundColor: Color(colors.surface.value),
        iconTheme: IconThemeData(color: Color(colors.onSurface.value)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const _RegisterForm();
              });
        },
        icon: Icon(
          Icons.person,
          color: Color(colors.onPrimary.value),
        ),
        label: Text(
          'Generar código',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(colors.onPrimary.value)),
        ),
        backgroundColor: Color(colors.primary.value),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Códigos generados',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Color(colors.secondary.value))),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: CodesSection(
              codes: codesState.codes,
            )),
          ],
        ),
      ),
    );
  }
}

class CodesSection extends ConsumerWidget {
  final List codes;
  const CodesSection({super.key, required this.codes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return codes.isEmpty
        ? Center(
            child: Text(
              'No hay códigos generados',
              style:
                  TextStyle(fontSize: 18, color: Color(colors.onSurface.value)),
            ),
          )
        : ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              final code = codes[index];
              return GestureDetector(
                onTap: () => {_copyTutorInfoToClipboard(code, context)},
                child: CardCode(
                  tutorId: code['codigo'],
                  name: code['tutor_nombre'],
                  lastName: code['tutor_apellido'],
                ),
              );
            },
          );
  }

  void _copyTutorInfoToClipboard(
      Map<String, dynamic> code, BuildContext context) {
    String clipboardText =
        "${code['codigo']}\n${code['tutor_nombre']} ${code['tutor_apellido']}";
    Clipboard.setData(ClipboardData(text: clipboardText));
  }
}

class CardCode extends StatelessWidget {
  final String tutorId;
  final String name;
  final String lastName;

  const CardCode({
    super.key,
    required this.tutorId,
    required this.name,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(colors.primaryContainer.value),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutorId,
                style: TextStyle(
                  color: Color(colors.secondary.value),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Text(
                '$name $lastName',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(colors.onPrimaryContainer.value),
                ),
              ),
            ],
          ),
          const Spacer(), // Esto empujará el icono de copiar hacia la derecha
          Icon(Icons.copy, color: colors.onPrimaryContainer,),
        ],
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(registerTutorProvider, (previous, next) {
      if (next.userRegistred == false) return;
      ref.read(codesProvider.notifier).loadCodes();
      context.pop();
    });

    final registerTutorState = ref.watch(registerTutorProvider);
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      content: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Datos del tutor',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(colors.secondary.value))),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: 'Nombre',
              onChanged: ref.read(registerTutorProvider.notifier).onNameChange,
              errorMessage: registerTutorState.isFormPosted
                  ? registerTutorState.name.errorMessage
                  : null,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: 'Apellido',
              onChanged:
                  ref.read(registerTutorProvider.notifier).onLastNameChange,
              errorMessage: registerTutorState.isFormPosted
                  ? registerTutorState.lastName.errorMessage
                  : null,
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
                  onPressed: registerTutorState.isPosting
                      ? null
                      : ref.read(registerTutorProvider.notifier).onFormSubmit,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Aceptar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
