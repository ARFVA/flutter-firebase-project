import 'package:firebase_storage/firebase_storage.dart';
import 'package:studyquest/core/errors/exceptions.dart';

abstract class StorageRemoteDataSource {
  Future<String> uploadFile(String path, dynamic file);
  Future<String> getDownloadUrl(String path);
  Future<void> deleteFile(String path);
}

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  final FirebaseStorage storage;

  StorageRemoteDataSourceImpl(this.storage);

  @override
  Future<String> uploadFile(String path, dynamic file) async {
    try {
      final ref = storage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return snapshot.ref.fullPath;
    } catch (e) {
      throw ServerException('Storage error: ${e.toString()}');
    }
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = storage.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw ServerException('Storage error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw ServerException('Storage error: ${e.toString()}');
    }
  }
}
