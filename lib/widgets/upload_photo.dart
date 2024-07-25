import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/services/camera_gallery_service.dart';

class UploadPhoto extends ConsumerWidget {
  const UploadPhoto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final photoState = ref.watch(photoProvider);
    late ImageProvider imageProvider;
    imageProvider = FileImage(File(photoState.image));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Para terminar, por favor sube una fotografía tuya',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 20,
        ),
        Text('Recomendaciones',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        Text('Foto de frente, rostro descubierto,',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        Text('tomada de los hombros hacia arriba',
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 20,
        ),
        photoState.image.isEmpty
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                width: 250,
                height: 150,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                    placeholder: const AssetImage('assets/loaders/loading.gif'),
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
              onPressed: () async {
                final photoPath = await CameraGalleryService().selectPhoto();
                if (photoPath == null) return;
                ref.read(photoProvider.notifier).onImageChanged(photoPath);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Seleccionar fotografía',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        photoState.image.isEmpty
            ? Container()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Color(colors.primary.value),
                        foregroundColor: Color(colors.onPrimary.value)),
                    onPressed: photoState.isPosting
                        ? null
                        : ref.read(photoProvider.notifier).onFormSubmit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Siguiente',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )),
              ),
      ],
    );
  }
}
