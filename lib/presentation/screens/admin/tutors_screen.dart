import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class TutorsScreen extends StatelessWidget {
  const TutorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/register/tutor');
        },
        icon: Icon(
          Icons.person,
          color: Color(colors.onPrimary.value),
        ),
        label: Text(
          'Nuevo tutor',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(colors.onPrimary.value)),
        ),
        backgroundColor: Color(colors.primary.value),
      ),
      body: const TutorsView(),
    );
  }
}

class TutorsView extends ConsumerWidget {
  const TutorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final tutorsState = ref.watch(tutorsProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tutores',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: Color(colors.secondary.value))),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: TutorsSection(
            tutors: tutorsState.tutors,
          )),
        ]));
  }
}

class TutorsSection extends ConsumerWidget {
  final List tutors;
  const TutorsSection({super.key, required this.tutors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(tutorsProvider.notifier).loadNextPage();
      }
    });
    return tutors.isEmpty
        ? Center(
            child: Text(
              'No hay tutores registrados',
              style:
                  TextStyle(fontSize: 18, color: Color(colors.onSurface.value)),
            ),
          )
        : ListView.builder(
            controller: scrollController,
            itemCount: tutors.length,
            itemBuilder: (context, index) {
              final tutor = tutors[index];
              return GestureDetector(
                onTap: () => {_copyTutorInfoToClipboard(tutor, context)},
                child: CardTutor(
                  tutorId: tutor['usuario_id'],
                  name: tutor['nombre'],
                  lastName: tutor['apellido'],
                  email: tutor['correo'],
                ),
              );
            },
          );
  }

  void _copyTutorInfoToClipboard(
      Map<String, dynamic> tutor, BuildContext context) {
    String clipboardText =
        "${tutor['usuario_id']}\n${tutor['nombre']} ${tutor['apellido']}\n${tutor['correo']}";
    Clipboard.setData(ClipboardData(text: clipboardText));
  }
}

class CardTutor extends StatelessWidget {
  final String tutorId;
  final String name;
  final String lastName;
  final String email;

  const CardTutor({
    super.key,
    required this.tutorId,
    required this.name,
    required this.lastName,
    required this.email,
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
            Text(
              email,
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
