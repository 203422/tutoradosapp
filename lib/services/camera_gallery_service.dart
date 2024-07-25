import 'package:image_picker/image_picker.dart';

class CameraGalleryService {
  final ImagePicker picker = ImagePicker();

  Future<String?> selectPhoto() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image == null) return null;
    return image.path;
  }
}
