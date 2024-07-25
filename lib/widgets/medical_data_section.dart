import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/widgets/widgets.dart';

class MedicalDataSection extends ConsumerWidget {
  const MedicalDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalProvider = ref.watch(medicalDataProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Num. Seguro social',
          isFormStudent: true,
          keyboardType: TextInputType.number,
          onChanged:
              ref.read(medicalDataProvider.notifier).onSocialNumberChanged,
          errorMessage: medicalProvider.isFormPosted
              ? medicalProvider.socialSecurityNumber.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          label: 'Tipo de sangre',
          isFormStudent: true,
          onChanged: ref.read(medicalDataProvider.notifier).onBloodTypeChanged,
          errorMessage: medicalProvider.isFormPosted
              ? medicalProvider.bloodType.errorMessage
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          '¿Padeces alguna enfermedad?',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        const DiseaseOption(),
        const SizedBox(
          height: 20,
        ),
        medicalProvider.disease
            ? CustomTextField(
                label: '¿Cúal?',
                isFormStudent: true,
                onChanged:
                    ref.read(medicalDataProvider.notifier).onDiseaseChanged,
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        Text(
          '¿Alérgico a algún medicamento y/o otro?',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        const AllergyOption(),
        const SizedBox(
          height: 20,
        ),
        medicalProvider.allergy
            ? CustomTextField(
                label: '¿Cúal?',
                isFormStudent: true,
                onChanged:
                    ref.read(medicalDataProvider.notifier).onAllergyChanged,
              )
            : Container(),
        const SizedBox(
          height: 20,
        ),
        const DisabilityOption(),
        const SizedBox(
          height: 20,
        ),
        const SubstanceOption(),
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
              onPressed: medicalProvider.isPosting
                  ? null
                  : ref.read(medicalDataProvider.notifier).onFormSubmit,
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

class DiseaseOption extends ConsumerWidget {
  const DiseaseOption({super.key});

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

class DisabilityOption extends ConsumerWidget {
  const DisabilityOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final medicalProvider = ref.watch(medicalDataProvider);

    return Container(
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
              return const Disability();
            },
          );
        },
        trailing: const Icon(Icons.arrow_drop_down),
        title: Text(
          '¿Tienes alguna discapacidad?',
          style: TextStyle(
            color: Color(colors.onPrimaryContainer.value),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          medicalProvider.disability
              ? '${medicalProvider.disabilities.first}...'
              : 'Ninguna',
          style: TextStyle(
              color: Color(colors.secondary.value),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AllergyOption extends ConsumerWidget {
  const AllergyOption({super.key});

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
            value: false, label: Text('No', style: TextStyle(fontSize: 16))),
        ButtonSegment(
            value: true, label: Text('Sí', style: TextStyle(fontSize: 16))),
      ],
      selected: {medicalProvider.allergy},
      onSelectionChanged: (newSelection) {
        ref
            .read(medicalDataProvider.notifier)
            .allergyIsSelected(newSelection.first);
      },
    );
  }
}

class Disability extends ConsumerWidget {
  const Disability({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final medicalProvider = ref.watch(medicalDataProvider);

    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            style: BorderStyle.solid,
            strokeAlign: 1,
            color: Color(colors.onSurface.value)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ListView(
        children: [
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: !medicalProvider.disability,
              shape: shape,
              title: const Text(
                'Ninguna',
              ),
              value: !medicalProvider.disability,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).disabilityIsSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.visual,
              shape: shape,
              title: const Text(
                'Visual',
              ),
              value: medicalProvider.visual,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).visualSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.intellectual,
              shape: shape,
              title: const Text(
                'Intelectual',
              ),
              value: medicalProvider.intellectual,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).intellectualSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.auditory,
              shape: shape,
              title: const Text(
                'Auditiva',
              ),
              value: medicalProvider.auditory,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).auditorySelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.physical,
              shape: shape,
              title: const Text(
                'Física/Motriz',
              ),
              value: medicalProvider.physical,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).physicalSelected();
              }),
        ],
      ),
    );
  }
}

class SubstanceOption extends ConsumerWidget {
  const SubstanceOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalProvider = ref.watch(medicalDataProvider);
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF989898),
            width: 1,
          )),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return const Substances();
            },
          );
        },
        trailing: const Icon(Icons.arrow_drop_down),
        title: Text(
          '¿Consumes sustancias tóxicas?',
          style: TextStyle(
            color: Color(colors.onPrimaryContainer.value),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          medicalProvider.sustance
              ? '${medicalProvider.sustances.first}...'
              : 'Ninguna',
          style: TextStyle(
              color: Color(colors.secondary.value),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Substances extends ConsumerWidget {
  const Substances({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalProvider = ref.watch(medicalDataProvider);
    final colors = Theme.of(context).colorScheme;

    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            style: BorderStyle.solid,
            strokeAlign: 1,
            color: Color(colors.onSurface.value)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ListView(
        children: [
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: !medicalProvider.sustance,
              shape: shape,
              title: const Text('Ninguna'),
              value: !medicalProvider.sustance,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).sustancesIsSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.alcohol,
              shape: shape,
              title: const Text('Alcohol'),
              value: medicalProvider.alcohol,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).alcoholSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.cigar,
              shape: shape,
              title: const Text('Cigarro'),
              value: medicalProvider.cigar,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).cigarSelected();
              }),
          const SizedBox(
            height: 10,
          ),
          CheckboxListTile(
              activeColor: Color(colors.secondary.value),
              checkColor: Color(colors.surface.value),
              selected: medicalProvider.drugs,
              shape: shape,
              title: const Text('Drogas'),
              value: medicalProvider.drugs,
              onChanged: (newValue) {
                ref.read(medicalDataProvider.notifier).drugsSelected();
              }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
