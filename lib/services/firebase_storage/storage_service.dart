import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> updateProfileImage({
    required File image,
  }) async {
    final _uid = _firebaseAuth.currentUser!.uid;

    final _ref = _firebaseStorage
        .ref()
        .child('user_profile_images')
        .child(_uid + 'profile_image.jpg');
    await _ref.putFile(image);

    return await _ref.getDownloadURL();
  }

  Future<void> deleteFileImage() async {
    final _uid = _firebaseAuth.currentUser!.uid;

    final _ref = _firebaseStorage
        .ref()
        .child('user_profile_images')
        .child(_uid + 'profile_image.jpg');
    return await _ref.delete();
  }

  Future<List> uploadPetitionImages({
    required List<XFile> images,
    required String petitionId,
  }) async {
    final _uid = _firebaseAuth.currentUser!.uid;
    List? _imageUrls = [];
    int _count = 0;

    for (var image in images) {
      final _ref = _firebaseStorage.ref().child('petition_images').child(_uid +
          '_' +
          petitionId +
          '_' +
          'petition_image' +
          _count.toString() +
          '.jpg');

      await _ref.putFile(File(image.path));

      final _downloadUrl = await _ref.getDownloadURL();
      _imageUrls.add(_downloadUrl);

      _count++;
    }

    return _imageUrls;
  }
}
