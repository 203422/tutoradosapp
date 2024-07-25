import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/form_providers/socieconomic_data_provider.dart';
import 'package:tutorados_app/widgets/custom_text_field.dart';

class SocioeconomicDataSection extends ConsumerWidget {
  const SocioeconomicDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socioeconomicProvider = ref.watch(socioeconomicDataProvider);
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Actualmente trabajas?',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        const WorkOption(),
        const SizedBox(
          height: 20,
        ),
        socioeconomicProvider.work
            ? CustomTextField(
                label: '¿Dónde?',
                isFormStudent: true,
                onChanged: ref
                    .read(socioeconomicDataProvider.notifier)
                    .onWorkplaceChanged,
              )
            : Container(),
        const SizedBox(
          height: 20,
        ),
        Text(
          '¿Cuenta con apoyo económico para sus estudios?',
          style: TextStyle(
              color: Color(colors.onPrimaryContainer.value),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        const EconomicalSupportOption(),
        const SizedBox(
          height: 30,
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
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return const Coexistence();
                },
              );
            },
            trailing: const Icon(Icons.arrow_drop_down),
            title: Text(
              '¿Con quién vives actualmente?',
              style: TextStyle(
                  color: Color(colors.onPrimaryContainer.value),
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              socioeconomicProvider.livesWith,
              style: TextStyle(
                  color: Color(colors.secondary.value),
                  fontWeight: FontWeight.bold),
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
              onPressed: socioeconomicProvider.isPosting
                  ? null
                  : ref.read(socioeconomicDataProvider.notifier).onFormSubmit,
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

class WorkOption extends ConsumerWidget {
  const WorkOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socioeconomicProvider = ref.watch(socioeconomicDataProvider);
    final colors = Theme.of(context).colorScheme;

    return SegmentedButton(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Color(colors.primary.value),
        selectedForegroundColor: Color(colors.onPrimary.value),
        shape: (ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12))),
      ),
      segments: const [
        ButtonSegment(value: false, label: Text('No')),
        ButtonSegment(value: true, label: Text('Sí')),
      ],
      selected: {socioeconomicProvider.work},
      onSelectionChanged: (newSelection) {
        ref
            .read(socioeconomicDataProvider.notifier)
            .onOptionWorkChanged(newSelection.first);
      },
    );
  }
}

class EconomicalSupportOption extends ConsumerWidget {
  const EconomicalSupportOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socioeconomicProvider = ref.watch(socioeconomicDataProvider);
    final colors = Theme.of(context).colorScheme;
    return SegmentedButton(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Color(colors.primary.value),
        selectedForegroundColor: Color(colors.onPrimary.value),
        shape: (ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12))),
      ),
      segments: const [
        ButtonSegment(value: false, label: Text('No')),
        ButtonSegment(value: true, label: Text('Sí')),
      ],
      selected: {socioeconomicProvider.economicalSupport},
      onSelectionChanged: (newSelection) {
        ref
            .read(socioeconomicDataProvider.notifier)
            .onEconomicalSupportOptionChanged(newSelection.first);
      },
    );
  }
}

class Coexistence extends ConsumerWidget {
  const Coexistence({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socioeconomicProvider = ref.watch(socioeconomicDataProvider);
    final colors = Theme.of(context).colorScheme;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            style: BorderStyle.solid,
            strokeAlign: 1,
            color: Color(colors.onSurface.value)));

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                selected: socioeconomicProvider.livesWith == 'Solo',
                activeColor: Color(colors.secondary.value),
                shape: shape,
                value: 'Solo',
                title: const Text('Solo'),
                groupValue: socioeconomicProvider.livesWith,
                onChanged: (newValue) {
                  ref
                      .read(socioeconomicDataProvider.notifier)
                      .onLiveWithChanged(newValue.toString());
                      Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              RadioListTile(
                  selected: socioeconomicProvider.livesWith == 'Padres',
                  activeColor: Color(colors.secondary.value),
                  shape: shape,
                  value: 'Padres',
                  title: const Text('Padres'),
                  groupValue: socioeconomicProvider.livesWith,
                  onChanged: (newValue) {
                    ref
                        .read(socioeconomicDataProvider.notifier)
                        .onLiveWithChanged(newValue.toString());
                        Navigator.of(context).pop();
                  }),
              const SizedBox(
                height: 10,
              ),
              RadioListTile(
                  selected: socioeconomicProvider.livesWith == 'Amigos',
                  activeColor: Color(colors.secondary.value),
                  shape: shape,
                  value: 'Amigos',
                  title: const Text('Amigos'),
                  groupValue: socioeconomicProvider.livesWith,
                  onChanged: (newValue) {
                    ref
                        .read(socioeconomicDataProvider.notifier)
                        .onLiveWithChanged(newValue.toString());
                        Navigator.of(context).pop();
                  }),
              const SizedBox(
                height: 10,
              ),
              RadioListTile(
                  selected:
                      socioeconomicProvider.livesWith == 'Uno de sus padres',
                  activeColor: Color(colors.secondary.value),
                  shape: shape,
                  value: 'Uno de sus padres',
                  title: const Text('Uno de sus padres'),
                  groupValue: socioeconomicProvider.livesWith,
                  onChanged: (newValue) {
                    ref
                        .read(socioeconomicDataProvider.notifier)
                        .onLiveWithChanged(newValue.toString());
                        Navigator.of(context).pop();
                  }),
              const SizedBox(
                height: 10,
              ),
              RadioListTile(
                  selected: socioeconomicProvider.livesWith == 'Pareja',
                  activeColor: Color(colors.secondary.value),
                  shape: shape,
                  value: 'Pareja',
                  title: const Text('Pareja'),
                  groupValue: socioeconomicProvider.livesWith,
                  onChanged: (newValue) {
                    ref
                        .read(socioeconomicDataProvider.notifier)
                        .onLiveWithChanged(newValue.toString());
                        Navigator.of(context).pop();
                  }),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                label: 'Otros, especifique',
                onChanged: ref
                    .read(socioeconomicDataProvider.notifier)
                    .onAnotherOption,
                controller:
                    ref.read(socioeconomicDataProvider.notifier).anotherOption,
              )
            ],
          ),
        ),
      ),
    );
  }
}
