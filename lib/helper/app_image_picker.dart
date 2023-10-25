import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workoutdiary/common/colo_extension.dart';

class AppImagePicker {
  ImageSource source;

  AppImagePicker({required this.source});

  pick({onPick}) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      await [Permission.storage].request();

      // onPick(File(img.path));
      onPick(img);
    } else {
      onPick(null);
    }
  }
}

//0. (업데이트) 이미지 자르기
Future<File?> _cropImage({required File imageFile}) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    compressQuality: 100,
    aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
    aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio16x9,
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '자르기',
        toolbarColor: TColor.white,
        toolbarWidgetColor: TColor.black,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: '자르기',
        doneButtonTitle: '완료',
        cancelButtonTitle: '취소',
        aspectRatioLockEnabled: true,
      ),
    ],
  );
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}
