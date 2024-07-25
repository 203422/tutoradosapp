import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/form_providers/form_state_provider.dart';

class FormCompletedFeedback extends ConsumerWidget {
  const FormCompletedFeedback({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void showDialogInfo(BuildContext context, String pathFile) {
      showDialog(
          context: context,
          builder: (context) {
            return _DocInfo(
              filePath: pathFile,
            );
          }).then((value) => {
            ref.read(formProvider.notifier).closeFileInfo()
          });
    }

    final formState = ref.watch(formProvider);
    ref.listen(formProvider, (previous, next) {
      if (next.isFileDownloaded && next.pathFile.isNotEmpty) {
        showDialogInfo(context, next.pathFile);
      }
    });

    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text('¡Gracias por completar el formulario!',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
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
              onPressed: formState.pdfIsDownloading
                  ? null
                  : () {
                      ref.read(formProvider.notifier).getFile('pdf');
                    },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Descargar PDF',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
        ),
      ],
    );
  }
}

class _DocInfo extends ConsumerWidget {
  final String filePath;
  const _DocInfo({required this.filePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
        title: const Text('Archivo descargado'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton.icon(
              onPressed: () {
                ref.read(formProvider.notifier).closeFileInfo();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check, color: Color(colors.secondary.value)),
              label: Text(
                'Aceptar',
                style: TextStyle(color: Color(colors.secondary.value)),
              )),
          TextButton.icon(
              onPressed: () {
                ref.read(formProvider.notifier).openFile();
                ref.read(formProvider.notifier).closeFileInfo();
                Navigator.of(context).pop();
              },
              icon:
                  Icon(Icons.open_in_new, color: Color(colors.secondary.value)),
              label: Text(
                'Abrir',
                style: TextStyle(color: Color(colors.secondary.value)),
              ))
        ],
        content: SizedBox(
          width: double.maxFinite,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruta del archivo:',
                style: TextStyle(
                    fontSize: 16, color: Color(colors.secondary.value)),
              ),
              Text(
                filePath,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
