import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class FirstSectionOfStudentData extends ConsumerWidget {
  const FirstSectionOfStudentData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstStudentData = ref.watch(firstStudentDataProvider);
    final userState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Nombre',
          isFormStudent: true,
          initialValue: userState.user?.name,
          onChanged: ref.read(firstStudentDataProvider.notifier).onNameChanged,
          errorMessage: firstStudentData.isFormPosted
              ? firstStudentData.name.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          label: 'Apellido',
          isFormStudent: true,
          initialValue: userState.user?.lastName,
          errorMessage: firstStudentData.isFormPosted
              ? firstStudentData.lastName.errorMessage
              : null,
          onChanged:
              ref.read(firstStudentDataProvider.notifier).onLastNameChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          enabled: false,
          label: 'Matrícula',
          isFormStudent: true,
          initialValue: userState.user?.id,
          errorMessage: firstStudentData.isFormPosted
              ? firstStudentData.studentEnrollment.errorMessage
              : null,
          onChanged: ref
              .read(firstStudentDataProvider.notifier)
              .onStudentEnrollmentChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Género',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        const SelectGender(),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(colors.onSurface.value),
                width: 1,
              )),
          child: ListTile(
            onTap: () {
              showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return const SelectCareer();
                },
              );
            },
            trailing: const Icon(Icons.arrow_drop_down),
            title: Text('Programa académico',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(colors.onPrimaryContainer.value),
                    fontWeight: FontWeight.bold)),
            subtitle: Text(
              firstStudentData.career.value,
              style: TextStyle(
                  color: Color(colors.secondary.value),
                  fontWeight: FontWeight.w500),
            ),
          ),
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
              onPressed:
                  ref.read(firstStudentDataProvider.notifier).onFormSubmit,
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

class SelectGender extends ConsumerWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstStudentData = ref.watch(firstStudentDataProvider);
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
            value: 'Masculino',
            label: Text(
              'Masculino',
              style: TextStyle(fontSize: 16),
            ),
            icon: Icon(Icons.male)),
        ButtonSegment(
            value: 'Femenino',
            label: Text('Femenino', style: TextStyle(fontSize: 16)),
            icon: Icon(Icons.female)),
      ],
      selected: {firstStudentData.gender.value},
      onSelectionChanged: (newSelection) {
        ref
            .read(firstStudentDataProvider.notifier)
            .onGenderChanged(newSelection.first.toString());
      },
    );
  }
}
