import 'package:flutter/foundation.dart';

@immutable
abstract class Model {
  Future<bool> create({required Map<String, dynamic> data});

  Future<Map<String, dynamic>?> read({required String uuid});

  Future<List<Map<String, dynamic>?>?> readAll();

  Future<bool> update({required String uuid});

  Future<bool> delete({required String uuid});
}
