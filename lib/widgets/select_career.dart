import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/form_providers/first_section_of_student_data_provider.dart';

class SelectCareer extends ConsumerWidget {
  const SelectCareer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstStudentData = ref.watch(firstStudentDataProvider);
    final colors = Theme.of(context).colorScheme;

    final borderShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            style: BorderStyle.solid,
            strokeAlign: 1,
            color: Color(colors.onSurface.value)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView(
        children: [
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería en Software',
              title: Text(
                'Software',
                style: TextStyle(color: Color(colors.onSurface.value)),
              ),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería Agroindustrial',
              title: const Text('Agroindustrial'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería en Tecnología Ambiental',
              title: const Text('Ambiental'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería Biomédica',
              title: const Text('Biomédica'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería en Energía',
              title: const Text('Energía'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería en Tecnologías de Manufactura',
              title: const Text('Manufactura'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería Mecatrónica',
              title: const Text('Mecatrónica'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería en Nanotecnología',
              title: const Text('Nanotecnología'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Ingeniería Petrolera',
              title: const Text('Petrolera'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
              activeColor: Color(colors.secondary.value),
              shape: borderShape,
              value: 'Licenciatura en Administración y Gestión Empresarial',
              title: const Text('LAGE'),
              groupValue: firstStudentData.career.value,
              onChanged: (newValue) {
                ref
                    .read(firstStudentDataProvider.notifier)
                    .onCareerChanged(newValue.toString());
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
