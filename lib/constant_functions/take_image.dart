import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> takeImage(userId) async {
  File newImage;
  String? imageUrl;
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) {
    return '';
  }

  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.absolute.path}/temp.jpg';

  final result = await FlutterImageCompress.compressAndGetFile(
    image.path,
    targetPath,
    minHeight: 1080,
    minWidth: 1080,
    quality: 35,
  );

  newImage = File(result!.path);

  String filePath = 'users/$userId/${DateTime
      .now()
      .millisecondsSinceEpoch}';
  await FirebaseStorage.instance.ref(filePath).putFile(newImage);
  imageUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();

  return imageUrl ?? '';
}
