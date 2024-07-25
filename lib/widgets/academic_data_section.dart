import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class AcademicDataSection extends ConsumerWidget {
  const AcademicDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final academicProvider = ref.watch(academicDataProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          isFormStudent: true,
          label: 'Preparatoria de origen',
          errorMessage: (academicProvider.messageHighSchool != '')
              ? academicProvider.messageHighSchool
              : null,
          onChanged:
              ref.read(academicDataProvider.notifier).onHighSchoolChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          isFormStudent: true,
          label: 'Promedio general',
          errorMessage: (academicProvider.messageAverage != '')
              ? academicProvider.messageAverage
              : null,
          keyboardType: TextInputType.number,
          onChanged: ref.read(academicDataProvider.notifier).onAverageChanged,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Puntuación examen CENEVAL',
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
          keyboardType: TextInputType.number,
          onFieldSubmitted: (_) => ref.read(academicDataProvider.notifier).onFormSubmit(),
          label: 'Puntuación',
          errorMessage: (academicProvider.messageScore != '')
              ? academicProvider.messageScore
              : null,
          onChanged: ref.read(academicDataProvider.notifier).onScoreCeneval,
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
              onPressed: academicProvider.isPosting
                  ? null
                  : ref.read(academicDataProvider.notifier).onFormSubmit,
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
