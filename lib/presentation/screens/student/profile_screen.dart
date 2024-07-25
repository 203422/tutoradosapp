import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/custom_text_field.dart';

class ProfileStudentScreen extends ConsumerStatefulWidget {
  final String studentId;

  const ProfileStudentScreen({super.key, required this.studentId});

  @override
  _ProfileStudentScreenState createState() => _ProfileStudentScreenState();
}

class _ProfileStudentScreenState extends ConsumerState<ProfileStudentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileFormProvider(widget.studentId).notifier).getStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileStudentState =
        ref.watch(profileFormProvider(widget.studentId));
    final colors = Theme.of(context).colorScheme;

    ref.listen(profileFormProvider(widget.studentId), (previous, next) {
      if (next.message.isEmpty) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(next.message)));
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref
                    .read(profileFormProvider(widget.studentId).notifier)
                    .onContactDataSubmit();
                ref
                    .read(profileFormProvider(widget.studentId).notifier)
                    .onPrifileUpdate();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: profileStudentState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : _StudentViewInfo(
              student: profileStudentState.student,
            ),
    );
  }
}

class _StudentViewInfo extends StatelessWidget {
  final Student? student;
  const _StudentViewInfo({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderContainer(
              image: student?.image ?? 'Sin fotografía',
              studentId: student?.studentEnrollment ?? 'Sin id',
              name: student?.name ?? 'nombre',
              lastName: student?.lastName ?? 'apellido',
              email: student?.email ?? 'email',
              career: student?.career ?? 'carrera',
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Contacto',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(colors.secondary.value)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _ContactData(student: student),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String image;
  const _ImageViewer({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: FadeInImage(
        fit: BoxFit.cover,
        image: NetworkImage('${Environment.apiUrl}/$image'),
        placeholder: const AssetImage('assets/loaders/loading.gif'),
      ),
    );
  }
}

class _HeaderContainer extends ConsumerWidget {
  final String image;
  final String studentId;
  final String name;
  final String lastName;
  final String email;
  final String career;
  const _HeaderContainer({
    super.key,
    required this.image,
    required this.studentId,
    required this.name,
    required this.lastName,
    required this.email,
    required this.career,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: _ImageViewer(image: image),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              studentId,
              style: TextStyle(
                  fontSize: 34,
                  color: Color(colors.secondary.value),
                  fontWeight: FontWeight.w700),
            ),
            Text(career,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(colors.onSurface.value),
                    fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: 'Nombre',
              initialValue: name,
              onChanged: ref
                  .read(profileFormProvider(studentId).notifier)
                  .onNameChanged,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: 'Apellido',
              initialValue: lastName,
              onChanged: ref
                  .read(profileFormProvider(studentId).notifier)
                  .onLastNameChanged,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              label: 'Correo',
              initialValue: email,
              onChanged: ref
                  .read(profileFormProvider(studentId).notifier)
                  .onEmailChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactData extends ConsumerWidget {
  final Student? student;
  const _ContactData({super.key, this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextField(
            label: 'Celular',
            initialValue: student?.cellPhoneNumber ?? 'Sin informacion',
            onChanged: ref
                .read(profileFormProvider(student!.studentEnrollment).notifier)
                .onCellPhoneNumberChanged,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            label: 'Tel. Casa',
            initialValue: student?.homePhoneNumber ?? 'Sin informacion',
            onChanged: ref
                .read(profileFormProvider(student!.studentEnrollment).notifier)
                .onHomePhoneNumberChanged,
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            label: 'Correo del tutor',
            initialValue: student?.tutorsEmail ?? 'Sin informacion',
            onChanged: ref
                .read(profileFormProvider(student!.studentEnrollment).notifier)
                .onTutorsEmailChanged,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            label: 'Domicilio actual',
            initialValue: student?.currentAddress ?? 'Sin informacion',
            onChanged: ref
                .read(profileFormProvider(student!.studentEnrollment).notifier)
                .onCurrentAddressChanged,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            label: 'Domicilio Familiar',
            initialValue: student?.homeAddress ?? 'Sin informacion',
            onChanged: ref
                .read(profileFormProvider(student!.studentEnrollment).notifier)
                .onHomeAddressChanged,
          ),
        ]));
  }
}
