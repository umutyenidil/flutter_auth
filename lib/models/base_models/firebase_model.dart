import 'package:flutter_auth/models/base_models/model.dart';

abstract class FirebaseModel extends Model {
  Future<Map<String, dynamic>?> readWithUid({required String uid});

  Future<bool> updateWithUid({
    required String uid,
    String? emailAddress,
  });

  Future<bool> deleteWithUid({required String uid});
}
