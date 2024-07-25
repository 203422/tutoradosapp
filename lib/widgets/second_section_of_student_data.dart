import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class SecondSectionOfStudentData extends ConsumerWidget {
  const SecondSectionOfStudentData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final secondStudentData = ref.watch(secondStudentDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          isFormStudent: true,
          errorMessage: secondStudentData.birthDate.errorMessage,
          label: 'Fecha de nacimiento',
          controller:
              ref.read(secondStudentDataProvider.notifier).birthDateController,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              ref
                  .read(secondStudentDataProvider.notifier)
                  .onBirthDateChanged(date);
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          errorMessage: secondStudentData.placeOfBirth.errorMessage,
          label: 'Lugar de nacimiento',
          onChanged: ref
              .read(secondStudentDataProvider.notifier)
              .onPlaceOfBirthChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Edad',
          keyboardType: TextInputType.number,
          controller:
              ref.read(secondStudentDataProvider.notifier).ageController,
          onChanged: ref.read(secondStudentDataProvider.notifier).onAgeChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Religión',
          hint: 'Ninguna',
          onChanged:
              ref.read(secondStudentDataProvider.notifier).onReligionChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Actividad cultural o deportiva que practiques',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Actividad',
          hint: 'Ninguna',
          onChanged:
              ref.read(secondStudentDataProvider.notifier).onActivityChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          errorMessage: secondStudentData.tutor.errorMessage,
          label: 'Tutor o padre de familia',
          onFieldSubmitted: (_) =>
              ref.read(secondStudentDataProvider.notifier).onFormSubmit(),
          onChanged:
              ref.read(secondStudentDataProvider.notifier).onTutorChanged,
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
              onPressed: secondStudentData.isPosting
                  ? null
                  : ref.read(secondStudentDataProvider.notifier).onFormSubmit,
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
